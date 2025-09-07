import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/models/player/info_model.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:card_battler/game/models/shared/value_image_label_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/services/game_state_facade.dart';
import 'package:card_battler/game/services/game_state_manager.dart';

void main() {
  group('Player Turn Integration Tests', () {
    late GameStateManager gameStateManager;
    late List<CardModel> playerDeckCards;
    late List<CardModel> enemyCards;
    late List<ShopCardModel> shopCards;

    setUp(() {
      // Reset game state for each test
      gameStateManager = GameStateManager();
      gameStateManager.reset();
      GameStateFacade.instance.reset();

      // Create test cards for the game
      playerDeckCards = [
        CardModel(name: 'Attack Card', type: 'attack'),
        CardModel(name: 'Defense Card', type: 'defense'),
        CardModel(name: 'Heal Card', type: 'heal'),
      ];

      enemyCards = [
        CardModel(name: 'Enemy Attack', type: 'attack'),
        CardModel(name: 'Enemy Defense', type: 'defense'),
      ];

      shopCards = [
        ShopCardModel(name: 'Shop Card 1', cost: 10),
        ShopCardModel(name: 'Shop Card 2', cost: 20),
      ];
    });

    tearDown(() {
      gameStateManager.clearListeners();
      gameStateManager.reset();
      GameStateFacade.instance.reset();
    });

    group('Full Turn Cycle Tests', () {
      test('single player completes full turn cycle with all phase transitions', () {
        // Initialize game with single player
        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);
        
        final facade = GameStateFacade.instance;
        final playerTurn = facade.playerTurn;
        final selectedPlayer = facade.selectedPlayer;
        
        expect(selectedPlayer, isNotNull);
        expect(gameStateManager.currentPhase, equals(GamePhase.waitingToDrawCards));

        // Track phase transitions
        List<GamePhase> phaseHistory = [];
        gameStateManager.addPhaseChangeListener((prev, next) {
          phaseHistory.add(next);
        });

        // Add some cards to the player's hand manually to simulate drawing cards
        final testCards = [
          CardModel(name: 'Test Card 1', type: 'attack'),
          CardModel(name: 'Test Card 2', type: 'defense'),
        ];
        selectedPlayer!.handModel.addCards(testCards);

        // Phase 1: Draw cards phase transition (waitingToDrawCards -> cardsDrawnWaitingForEnemyTurn)
        playerTurn.handleTurnButtonPress();
        expect(gameStateManager.currentPhase, equals(GamePhase.cardsDrawnWaitingForEnemyTurn));

        // Phase 2: Enemy turn (cardsDrawnWaitingForEnemyTurn -> enemyTurn)
        playerTurn.handleTurnButtonPress();
        expect(gameStateManager.currentPhase, equals(GamePhase.enemyTurn));

        // Phase 3: Player turn (enemyTurn -> playerTurn)
        playerTurn.handleTurnButtonPress();
        expect(gameStateManager.currentPhase, equals(GamePhase.playerTurn));

        // Player action: End turn with cards in hand (should request confirmation)
        final initialHandSize = selectedPlayer.handModel.cards.length;
        bool confirmationRequested = false;
        gameStateManager.addConfirmationRequestListener(() {
          confirmationRequested = true;
        });

        playerTurn.handleTurnButtonPress();
        expect(confirmationRequested, isTrue);
        expect(gameStateManager.currentPhase, equals(GamePhase.playerTurn)); // Should not advance yet

        // Force end turn
        playerTurn.endTurn();
        expect(selectedPlayer.handModel.cards.isEmpty, isTrue);
        expect(selectedPlayer.discardModel.allCards.length, equals(initialHandSize));
        
        // After endTurn, should be in waitingToDrawCards since turnOver is now true
        expect(gameStateManager.currentPhase, equals(GamePhase.waitingToDrawCards));
        expect(selectedPlayer.turnOver, isTrue);

        // Verify complete phase cycle was recorded
        expect(phaseHistory, equals([
          GamePhase.cardsDrawnWaitingForEnemyTurn,
          GamePhase.enemyTurn,
          GamePhase.playerTurn,
          GamePhase.waitingToDrawCards,
        ]));
      });

      test('player turn with empty hand ends directly without confirmation', () {
        // Initialize game
        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);
        
        final facade = GameStateFacade.instance;
        final playerTurn = facade.playerTurn;
        final selectedPlayer = facade.selectedPlayer;

        // Advance to player turn phase
        gameStateManager.nextPhase(); // waitingToDrawCards -> cardsDrawnWaitingForEnemyTurn
        gameStateManager.nextPhase(); // cardsDrawnWaitingForEnemyTurn -> enemyTurn
        gameStateManager.nextPhase(); // enemyTurn -> playerTurn

        // Ensure hand is empty (should be by default since deck is empty)
        selectedPlayer!.handModel.clearCards();
        expect(selectedPlayer.handModel.cards.isEmpty, isTrue);

        bool confirmationRequested = false;
        gameStateManager.addConfirmationRequestListener(() {
          confirmationRequested = true;
        });

        // Player turn with empty hand should end directly
        playerTurn.handleTurnButtonPress();
        
        expect(confirmationRequested, isFalse); // No confirmation needed
        expect(gameStateManager.currentPhase, equals(GamePhase.waitingToDrawCards));
        expect(selectedPlayer.turnOver, isTrue);
      });
    });

    group('Multi-Player Turn Sequence Tests', () {
      test('multiple players take turns in correct sequence without skipping', () {
        // Initialize game state with multiple players
        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);
        
        final facade = GameStateFacade.instance;
        final allPlayers = facade.allPlayers;
        
        expect(allPlayers.length, greaterThan(1), reason: 'Test requires multiple players');
        
        // Track which players have taken turns
        List<String> playerTurnOrder = [];
        List<GamePhase> phaseTransitions = [];
        
        gameStateManager.addPhaseChangeListener((prev, next) {
          phaseTransitions.add(next);
          if (next == GamePhase.playerTurn) {
            final currentPlayer = facade.selectedPlayer;
            if (currentPlayer != null) {
              playerTurnOrder.add(currentPlayer.infoModel.name);
            }
          }
        });

        // Simulate multiple complete turn cycles
        for (int cycle = 0; cycle < 2; cycle++) {
          for (int playerIndex = 0; playerIndex < allPlayers.length; playerIndex++) {
            final currentPlayer = facade.selectedPlayer;
            expect(currentPlayer, isNotNull);
            expect(currentPlayer, equals(allPlayers[playerIndex]));

            // Complete full turn cycle for current player
            _simulateFullPlayerTurn(facade, gameStateManager);

            // Switch to next player (except on last player of last cycle)
            if (!(cycle == 1 && playerIndex == allPlayers.length - 1)) {
              _handlePlayerSwitch(facade, gameStateManager);
            }
          }
        }

        // Verify all players took turns in correct order
        expect(playerTurnOrder.length, equals(allPlayers.length * 2)); // 2 cycles
        
        // Verify no player was skipped - each player should appear exactly twice
        for (final player in allPlayers) {
          final playerTurnCount = playerTurnOrder.where((name) => name == player.infoModel.name).length;
          expect(playerTurnCount, equals(2), reason: 'Player ${player.infoModel.name} should have taken exactly 2 turns');
        }

        // Verify turn order is sequential (cycling through players)
        for (int i = 0; i < playerTurnOrder.length; i++) {
          final expectedPlayerIndex = i % allPlayers.length;
          final expectedPlayerName = allPlayers[expectedPlayerIndex].infoModel.name;
          expect(playerTurnOrder[i], equals(expectedPlayerName));
        }
      });

      test('player switching maintains game state consistency', () {
        // Initialize game state
        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);
        
        final facade = GameStateFacade.instance;
        final initialPlayerCount = facade.allPlayers.length;
        final firstPlayer = facade.selectedPlayer;
        
        expect(firstPlayer, isNotNull);
        expect(initialPlayerCount, greaterThan(1));

        // Complete a turn and switch to next player
        _simulateFullPlayerTurn(facade, gameStateManager);
        
        final playerBeforeSwitch = facade.selectedPlayer;
        expect(playerBeforeSwitch, equals(firstPlayer));
        expect(gameStateManager.currentPhase, equals(GamePhase.waitingToDrawCards));
        expect(playerBeforeSwitch!.turnOver, isTrue);

        // Switch to next player
        _handlePlayerSwitch(facade, gameStateManager);
        
        final playerAfterSwitch = facade.selectedPlayer;
        expect(playerAfterSwitch, isNotNull);
        expect(playerAfterSwitch, isNot(equals(firstPlayer)));
        expect(facade.allPlayers.length, equals(initialPlayerCount)); // Player count unchanged
        expect(gameStateManager.currentPhase, anyOf([
          GamePhase.waitingToDrawCards,
          GamePhase.cardsDrawnWaitingForEnemyTurn
        ]));

        // Verify the switched player has expected initial state
        expect(playerAfterSwitch!.turnOver, isFalse);
      });
    });

    group('Game State Validation Tests', () {
      test('hand and discard pile state changes correctly during turn', () {
        // Initialize game
        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);
        
        final facade = GameStateFacade.instance;
        final playerTurn = facade.playerTurn;
        final player = facade.selectedPlayer!;

        // Record initial state
        final initialDeckSize = player.deckModel.allCards.length;
        final initialDiscardSize = player.discardModel.allCards.length;
        
        expect(player.handModel.cards.isEmpty, isTrue);

        // Manually add cards to hand to simulate drawing cards
        final testCards = [
          CardModel(name: 'Test Card 1', type: 'attack'),
          CardModel(name: 'Test Card 2', type: 'defense'),
        ];
        player.handModel.addCards(testCards);
        
        final handSizeAfterDraw = player.handModel.cards.length;
        expect(handSizeAfterDraw, equals(2));

        // Complete turn cycle to player turn
        playerTurn.handleTurnButtonPress(); // waitingToDrawCards -> cardsDrawnWaitingForEnemyTurn
        playerTurn.handleTurnButtonPress(); // cardsDrawnWaitingForEnemyTurn -> enemyTurn
        playerTurn.handleTurnButtonPress(); // enemyTurn -> playerTurn

        // End turn (discard hand)
        playerTurn.endTurn();
        
        // Verify final state
        expect(player.handModel.cards.isEmpty, isTrue);
        expect(player.discardModel.allCards.length, equals(initialDiscardSize + handSizeAfterDraw));
        expect(gameStateManager.currentPhase, equals(GamePhase.waitingToDrawCards));
        expect(player.turnOver, isTrue);
      });

      test('shop state persists correctly across player turns', () {
        // Initialize game
        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);
        
        final facade = GameStateFacade.instance;
        final shop = facade.playerTurn.shopModel;
        
        // Record initial shop state
        final initialSelectableCards = List.from(shop.selectableCards);
        final initialShopCards = shop.selectableCards.length;
        
        expect(initialShopCards, greaterThan(0));

        // Complete a full turn cycle
        _simulateFullPlayerTurn(facade, gameStateManager);

        // Verify shop state after turn
        expect(shop.selectableCards.length, equals(initialShopCards)); // Shop should be refilled
        expect(shop.selectableCards.length, equals(initialSelectableCards.length));
        
        // Switch to next player if possible
        if (facade.allPlayers.length > 1) {
          _handlePlayerSwitch(facade, gameStateManager);
          
          final newPlayerShop = facade.playerTurn.shopModel;
          // Shop should be available to new player
          expect(newPlayerShop.selectableCards.length, greaterThan(0));
        }
      });

      test('player stats and health persist correctly across turns', () {
        // Initialize game
        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);
        
        final facade = GameStateFacade.instance;
        final player = facade.selectedPlayer!;
        
        // Record initial stats
        final initialHealth = player.infoModel.healthModel.currentHealth;
        final initialAttack = player.infoModel.attack.value;
        final initialCredits = player.infoModel.credits.value;
        
        // Complete a full turn
        _simulateFullPlayerTurn(facade, gameStateManager);
        
        // Stats should persist (no changes in basic turn)
        expect(player.infoModel.healthModel.currentHealth, equals(initialHealth));
        expect(player.infoModel.attack.value, equals(initialAttack));
        expect(player.infoModel.credits.value, equals(initialCredits));
        
        // Player should be marked as turn over
        expect(player.turnOver, isTrue);
      });
    });

    group('Edge Case Tests', () {
      test('handles rapid turn button presses without state corruption', () {
        // Initialize game
        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);
        
        final facade = GameStateFacade.instance;
        final playerTurn = facade.playerTurn;
        
        List<GamePhase> phaseTransitions = [];
        gameStateManager.addPhaseChangeListener((prev, next) {
          phaseTransitions.add(next);
        });

        // Rapidly press turn button multiple times
        for (int i = 0; i < 10; i++) {
          playerTurn.handleTurnButtonPress();
        }

        // Should complete multiple cycles without corruption
        expect(phaseTransitions.isNotEmpty, isTrue);
        expect(gameStateManager.currentPhase, isNotNull);
        
        // Verify game state is still valid
        final player = facade.selectedPlayer;
        expect(player, isNotNull);
        expect(player!.handModel, isNotNull);
        expect(player.deckModel, isNotNull);
        expect(player.discardModel, isNotNull);
      });

      test('handles player switching when only one player exists', () {
        // Initialize game
        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);
        
        final facade = GameStateFacade.instance;
        
        // If only one player, switching should handle gracefully
        if (facade.allPlayers.length == 1) {
          final originalPlayer = facade.selectedPlayer;
          
          // Complete turn and attempt switch
          _simulateFullPlayerTurn(facade, gameStateManager);
          
          // Attempt player switch
          final switchResult = facade.switchToNextPlayer();
          
          // With one player, should either return same player or handle gracefully
          expect(facade.selectedPlayer, isNotNull);
          expect(facade.allPlayers.length, equals(1));
        }
      });
    });
  });
}

/// Helper function to simulate a complete player turn cycle
void _simulateFullPlayerTurn(GameStateFacade facade, GameStateManager gameStateManager) {
  final playerTurn = facade.playerTurn;
  final initialPhase = gameStateManager.currentPhase;
  
  // If not at start of turn cycle, advance to it
  if (initialPhase == GamePhase.waitingToDrawCards) {
    playerTurn.handleTurnButtonPress(); // Draw cards
  }
  if (gameStateManager.currentPhase == GamePhase.cardsDrawnWaitingForEnemyTurn) {
    playerTurn.handleTurnButtonPress(); // Enemy turn
  }
  if (gameStateManager.currentPhase == GamePhase.enemyTurn) {
    playerTurn.handleTurnButtonPress(); // Player turn
  }
  
  // End player turn
  if (gameStateManager.currentPhase == GamePhase.playerTurn) {
    playerTurn.endTurn(); // Force end turn regardless of hand state
  }
  
  // After endTurn, should be in waitingToDrawCards with turnOver = true
  expect(gameStateManager.currentPhase, equals(GamePhase.waitingToDrawCards));
  expect(facade.selectedPlayer!.turnOver, isTrue);
}

/// Helper function to handle player switching
void _handlePlayerSwitch(GameStateFacade facade, GameStateManager gameStateManager) {
  // When turnOver is true and we're in waitingToDrawCards, nextPhase should go to cardsDrawnWaitingForPlayerSwitch
  expect(gameStateManager.currentPhase, equals(GamePhase.waitingToDrawCards));
  expect(facade.selectedPlayer!.turnOver, isTrue);
  
  // Call nextPhase to trigger the player switch logic
  gameStateManager.nextPhase(); // Should go to cardsDrawnWaitingForPlayerSwitch since turnOver = true
  expect(gameStateManager.currentPhase, equals(GamePhase.cardsDrawnWaitingForPlayerSwitch));
  
  // Now handle the actual player switch
  final playerTurn = facade.playerTurn;
  playerTurn.handleTurnButtonPress(); // Trigger switch to next player
  
  // After switch, should be ready for next player's turn
  expect(gameStateManager.currentPhase, anyOf([
    GamePhase.waitingToDrawCards,
    GamePhase.cardsDrawnWaitingForEnemyTurn
  ]));
}