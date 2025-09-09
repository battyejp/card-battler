import 'package:card_battler/game/models/shared/effect_model.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:card_battler/game/models/enemy/enemies_model.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/services/game_state/game_state_facade.dart';
import 'package:card_battler/game/models/shared/cards_model.dart';
import 'package:card_battler/game/models/player/info_model.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/player/player_turn_state.dart';
import 'package:card_battler/game/services/player/player_turn_coordinator.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:card_battler/game/models/shared/value_image_label_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/models/shop/shop_model.dart';
import 'package:card_battler/game/models/team/bases_model.dart';
import 'package:card_battler/game/models/team/team_model.dart';
import 'package:card_battler/game/models/team/players_model.dart';
import 'package:card_battler/game/services/game_state/game_state_manager.dart';
import 'package:card_battler/game/services/game_state/game_state_service.dart';
import 'package:card_battler/game/services/card/card_selection_service.dart';

void main() {
  group('PlayerTurnCoordinator', () {
    late PlayerModel playerModel;
    late TeamModel teamModel;
    late EnemiesModel enemiesModel;
    late ShopModel shopModel;
    late PlayerTurnCoordinator playerTurnModel;

    setUp(() { 
      // Reset GameStateManager and GameStateFacade to known state
      final gameStateManager = GameStateManager();
      gameStateManager.reset();
      GameStateFacade.instance.reset();

      final infoModel = InfoModel(
        attack: ValueImageLabelModel(value: 50, label: 'Attack'),
        credits: ValueImageLabelModel(value: 100, label: 'Credits'),
        healthModel: HealthModel(maxHealth: 100),
        name: 'TestPlayer',
      );

      final handModel = CardsModel<CardModel>();
      final deckModel = CardPileModel.empty();
      final discardModel = CardPileModel.empty();

      playerModel = PlayerModel(
        infoModel: infoModel,
        handModel: handModel,
        deckModel: deckModel,
        discardModel: discardModel,
        gameStateService: DefaultGameStateService(gameStateManager),
        cardSelectionService: DefaultCardSelectionService(),
      );

      teamModel = TeamModel(bases: BasesModel(bases: []), playersModel: PlayersModel(players: []));
      enemiesModel = EnemiesModel(
        totalEnemies: 0,
        maxNumberOfEnemiesInPlay: 3,
        maxEnemyHealth: 50,
        enemyCards: [],
      );

      final shopCards = List.generate(10, (index) => 
        ShopCardModel(name: 'Shop Card ${index + 1}', cost: 10)
      );
      shopModel = ShopModel(
        numberOfRows: 2, 
        numberOfColumns: 3,
        cards: shopCards
      );

      final gameStateService = DefaultGameStateService(gameStateManager);
      final playerTurnState = PlayerTurnState(
        playerModel: playerModel,
        teamModel: teamModel,
        enemiesModel: enemiesModel,
        shopModel: shopModel,
      );
      playerTurnModel = PlayerTurnCoordinator(
        state: playerTurnState,
        gameStateService: gameStateService,
      );
    });

    group('constructor and initialization', () {
      test('creates with all required models', () {
        expect(playerTurnModel.playerModel, equals(playerModel));
        expect(playerTurnModel.teamModel, equals(teamModel));
        expect(playerTurnModel.enemiesModel, equals(enemiesModel));
        expect(playerTurnModel.shopModel, equals(shopModel));
      });

      test('sets up card played callbacks', () {
        expect(playerModel.cardPlayed, isNotNull);
        expect(shopModel.cardPlayed, isNotNull);
      });

      test('selectedPlayer is initialized to first player', () {
        expect(GameStateModel.instance.selectedPlayer, isNotNull);
        expect(GameStateModel.instance.selectedPlayer?.infoModel.name, equals('Player 1'));
      });
    });

    group('onCardPlayed method', () {
      test('handles regular card play correctly', () {
        final card = CardModel(name: 'Test Card', type: 'attack');
        card.isFaceUp = true;
        playerModel.handCards.addCard(card);

        final initialHandSize = playerModel.handCards.cards.length;
        final initialDiscardSize = playerModel.discardCards.allCards.length;

        playerTurnModel.onCardPlayed(card);

        expect(card.isFaceUp, isFalse);
        expect(playerModel.handCards.cards.length, equals(initialHandSize - 1));
        expect(playerModel.discardCards.allCards.length, equals(initialDiscardSize + 1));
        expect(playerModel.discardCards.allCards.contains(card), isTrue);
      });

      test('handles shop card play correctly', () {
        final shopCard = shopModel.selectableCards.first;
        final initialCredits = playerModel.infoModel.credits.value;
        final initialShopSize = shopModel.selectableCards.length;
        final initialDiscardSize = playerModel.discardCards.allCards.length;

        playerTurnModel.onCardPlayed(shopCard);

        expect(shopCard.isFaceUp, isFalse);
        expect(shopModel.selectableCards.length, equals(initialShopSize - 1));
        expect(playerModel.infoModel.credits.value, equals(initialCredits - shopCard.cost));
        expect(playerModel.discardCards.allCards.length, equals(initialDiscardSize + 1));
        expect(playerModel.discardCards.allCards.contains(shopCard), isTrue);
      });

      test('calls applyCardEffects after handling card', () {
        final card = CardModel(
          name: 'Credit Card', 
          type: 'utility',
          effects: [EffectModel(type: EffectType.credits, target: EffectTarget.self, value: 25)]
        );
        playerModel.handCards.addCard(card);

        final initialCredits = playerModel.infoModel.credits.value;

        playerTurnModel.onCardPlayed(card);

        expect(playerModel.infoModel.credits.value, equals(initialCredits + 25));
      });
    });

    group('handleTurnButtonPress method', () {
      late GameStateManager gameStateManager;
      
      setUp(() {
        gameStateManager = GameStateManager();
        gameStateManager.reset();
      });

      test('advances to next phase when not in playerTurn', () {
        // Test from waitingToDrawCards
        expect(gameStateManager.currentPhase, equals(GamePhase.waitingToDrawCards));
        playerTurnModel.handleTurnButtonPress();
        expect(gameStateManager.currentPhase, equals(GamePhase.cardsDrawnWaitingForEnemyTurn));

        // Test from cardsDrawn
        playerTurnModel.handleTurnButtonPress();
        expect(gameStateManager.currentPhase, equals(GamePhase.enemyTurn));

        // Test from enemyTurn
        playerTurnModel.handleTurnButtonPress();
        expect(gameStateManager.currentPhase, equals(GamePhase.playerTurn));
      });

      test('requests confirmation when in playerTurn with cards in hand', () {
        // Setup: advance to playerTurn phase and add cards to hand
        gameStateManager.nextPhase(); // waitingToDrawCards -> cardsDrawn
        gameStateManager.nextPhase(); // cardsDrawn -> enemyTurn
        gameStateManager.nextPhase(); // enemyTurn -> playerTurn

        final card = CardModel(name: 'Test Card', type: 'basic');
        playerModel.handCards.addCard(card);

        bool confirmationRequested = false;
        gameStateManager.addConfirmationRequestListener(() {
          confirmationRequested = true;
        });

        playerTurnModel.handleTurnButtonPress();

        expect(confirmationRequested, isTrue);
        expect(gameStateManager.currentPhase, equals(GamePhase.playerTurn)); // Phase should not change
      });

      test('ends turn directly when in playerTurn with empty hand', () {
        // Setup: advance to playerTurn phase with empty hand
        gameStateManager.nextPhase(); // waitingToDrawCards -> cardsDrawn
        gameStateManager.nextPhase(); // cardsDrawn -> enemyTurn
        gameStateManager.nextPhase(); // enemyTurn -> playerTurn

        expect(playerModel.handCards.cards.isEmpty, isTrue);

        playerTurnModel.handleTurnButtonPress();

        // Should advance to waitingToDrawCards (endTurn calls nextPhase)
        expect(gameStateManager.currentPhase, equals(GamePhase.waitingToDrawCards));
      });

      test('endTurn method advances phase and resets hand', () {
        // Setup: advance to playerTurn phase and add cards
        gameStateManager.nextPhase(); // waitingToDrawCards -> cardsDrawn
        gameStateManager.nextPhase(); // cardsDrawn -> enemyTurn
        gameStateManager.nextPhase(); // enemyTurn -> playerTurn

        final card1 = CardModel(name: 'Card 1', type: 'basic');
        final card2 = CardModel(name: 'Card 2', type: 'basic');
        playerModel.handCards.addCards([card1, card2]);
        
        expect(playerModel.handCards.cards.length, equals(2));

        playerTurnModel.endTurn();

        expect(playerModel.handCards.cards.isEmpty, isTrue);
        expect(gameStateManager.currentPhase, equals(GamePhase.waitingToDrawCards));
        expect(playerModel.discardCards.allCards.length, equals(0)); // Cards moved to deck due to reshuffle
        expect(playerModel.deckCards.allCards.length, equals(2)); // Cards reshuffled into deck
      });

      test('turn button behavior varies correctly by phase', () {
        final phases = [
          GamePhase.waitingToDrawCards,
          GamePhase.cardsDrawnWaitingForEnemyTurn,
          GamePhase.enemyTurn,
          GamePhase.playerTurn
        ];

        for (int i = 0; i < phases.length; i++) {
          // Reset and advance to the current phase
          gameStateManager.reset();
          // Reset turnOver flag to ensure proper phase progression
          GameStateFacade.instance.selectedPlayer?.turnOver = false;
          for (int j = 0; j < i; j++) {
            gameStateManager.nextPhase();
          }

          expect(gameStateManager.currentPhase, equals(phases[i]));

          if (phases[i] == GamePhase.playerTurn) {
            // In playerTurn, behavior depends on hand state
            expect(playerModel.handCards.cards.isEmpty, isTrue);
            
            playerTurnModel.handleTurnButtonPress();
            expect(gameStateManager.currentPhase, equals(GamePhase.waitingToDrawCards));
          } else {
            // In other phases, should advance to next phase
            final nextPhaseIndex = (i + 1) % phases.length;
            playerTurnModel.handleTurnButtonPress();
            expect(gameStateManager.currentPhase, equals(phases[nextPhaseIndex]));
          }
        }
      });
    });
  });
}