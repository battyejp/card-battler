import 'package:card_battler/game/models/shared/effect_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/services/enemy/enemy_turn_coordinator.dart';
import 'package:card_battler/game/models/shared/cards_model.dart';
import 'package:card_battler/game/models/team/player_stats_model.dart';
import 'package:card_battler/game/models/team/players_model.dart';
import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/services/game_state/game_state_manager.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/services/game_state/game_state_service.dart';

List<CardModel> _generateTestCards(int count) {
  return List.generate(
    count,
    (index) => CardModel(
      name: 'Enemy Card $index',
      type: 'enemy',
      isFaceUp: false,
      effects: [
        EffectModel(
          type: EffectType.attack,
          target: EffectTarget.activePlayer,
          value: 10 + index,
        ),
      ],
    ),
  );
}

PlayerStatsModel _createTestPlayerStats(
  String name, {
  bool isActive = false,
  int health = 100,
}) {
  final healthModel = HealthModel(maxHealth: health);
  return PlayerStatsModel(name: name, health: healthModel, isActive: isActive);
}

void main() {
  group('EnemyTurnCoordinator', () {
    group('constructor and initialization', () {
      test('creates with required parameters', () {
        final enemyCards = CardPileModel(cards: _generateTestCards(5));
        final playerStats = [_createTestPlayerStats('Player1', isActive: true)];

        final enemyTurnArea = EnemyTurnCoordinator(
          enemyCards: enemyCards,
          playersModel: PlayersModel(players: playerStats),
          gameStateService: DefaultGameStateService(GameStateManager()),
        );

        expect(enemyTurnArea.enemyCards, equals(enemyCards));
        expect(enemyTurnArea.playersModel.players, equals(playerStats));
        expect(enemyTurnArea.playedCards.hasNoCards, isTrue);
      });

      test('initializes empty played cards pile', () {
        final enemyCards = CardPileModel(cards: _generateTestCards(3));
        final playerStats = [_createTestPlayerStats('Player1')];

        final enemyTurnArea = EnemyTurnCoordinator(
          enemyCards: enemyCards,
          playersModel: PlayersModel(players: playerStats),
          gameStateService: DefaultGameStateService(GameStateManager()),
        );

        expect(enemyTurnArea.playedCards.hasNoCards, isTrue);
        expect(enemyTurnArea.playedCards.allCards.length, equals(0));
      });

      test('works with multiple player stats', () {
        final enemyCards = CardPileModel(cards: _generateTestCards(1));
        final playerStats = [
          _createTestPlayerStats('Player1', isActive: true),
          _createTestPlayerStats('Player2'),
          _createTestPlayerStats('Player3'),
        ];

        final enemyTurnArea = EnemyTurnCoordinator(
          enemyCards: enemyCards,
          playersModel: PlayersModel(players: playerStats),
          gameStateService: DefaultGameStateService(GameStateManager()),
        );

        expect(enemyTurnArea.playersModel.players.length, equals(3));
        expect(enemyTurnArea.playersModel.players[0].name, equals('Player1'));
        expect(enemyTurnArea.playersModel.players[0].isActive, isTrue);
        expect(enemyTurnArea.playersModel.players[1].isActive, isFalse);
      });
    });

    group('drawCardsFromDeck functionality', () {
      test('draws card from enemy deck and adds to played cards', () {
        final testCards = _generateTestCards(3);
        final enemyCards = CardPileModel(cards: testCards);
        final playerStats = [_createTestPlayerStats('Player1', isActive: true)];

        final enemyTurnArea = EnemyTurnCoordinator(
          enemyCards: enemyCards,
          playersModel: PlayersModel(players: playerStats),
          gameStateService: DefaultGameStateService(GameStateManager()),
        );

        final initialEnemyCount = enemyTurnArea.enemyCards.allCards.length;
        final initialPlayedCount = enemyTurnArea.playedCards.allCards.length;

        enemyTurnArea.drawCardsFromDeck();

        expect(
          enemyTurnArea.enemyCards.allCards.length,
          equals(initialEnemyCount - 1),
        );
        expect(
          enemyTurnArea.playedCards.allCards.length,
          equals(initialPlayedCount + 1),
        );
      });

      test('drawn card is automatically set to face up by CardsModel', () {
        final testCards = _generateTestCards(1);
        final enemyCards = CardPileModel(cards: testCards);
        final playerStats = [_createTestPlayerStats('Player1', isActive: true)];

        final enemyTurnArea = EnemyTurnCoordinator(
          enemyCards: enemyCards,
          playersModel: PlayersModel(players: playerStats),
          gameStateService: DefaultGameStateService(GameStateManager()),
        );

        // Verify card starts face down
        expect(testCards[0].isFaceUp, isFalse);

        enemyTurnArea.drawCardsFromDeck();

        // Verify played card is now face up (handled by CardsModel.drawCard())
        expect(enemyTurnArea.playedCards.allCards.first.isFaceUp, isTrue);
      });
    });

    group('integration tests', () {
      test('full turn simulation with damage', () {
        final testCards = [
          CardModel(
            name: 'Fireball',
            type: 'enemy',
            isFaceUp: false,
            effects: [
              EffectModel(
                type: EffectType.attack,
                target: EffectTarget.activePlayer,
                value: 30,
              ),
            ],
          ),
        ];

        final enemyCards = CardPileModel(cards: testCards);
        final activePlayer = _createTestPlayerStats(
          'Hero',
          isActive: true,
          health: 100,
        );
        final playerStats = [activePlayer];

        final enemyTurnArea = EnemyTurnCoordinator(
          enemyCards: enemyCards,
          playersModel: PlayersModel(players: playerStats),
          gameStateService: DefaultGameStateService(GameStateManager()),
        );

        // Verify initial state
        expect(enemyTurnArea.playedCards.hasNoCards, isTrue);
        expect(activePlayer.health.currentHealth, equals(100));

        // Execute turn
        enemyTurnArea.drawCardsFromDeck();

        // Verify final state
        expect(enemyTurnArea.playedCards.allCards.length, equals(1));
        expect(enemyTurnArea.playedCards.allCards.first.isFaceUp, isTrue);
        expect(
          enemyTurnArea.playedCards.allCards.first.name,
          equals('Fireball'),
        );
        expect(activePlayer.health.currentHealth, equals(70)); // 100 - 30
      });

      test('turn with no active players', () {
        final testCards = _generateTestCards(1);
        final enemyCards = CardPileModel(cards: testCards);
        final playerStats = [
          _createTestPlayerStats('Player1', isActive: false, health: 100),
          _createTestPlayerStats('Player2', isActive: false, health: 80),
        ];

        final enemyTurnArea = EnemyTurnCoordinator(
          enemyCards: enemyCards,
          playersModel: PlayersModel(players: playerStats),
          gameStateService: DefaultGameStateService(GameStateManager()),
        );

        enemyTurnArea.drawCardsFromDeck();

        // Turn should complete but no damage should be applied
        expect(playerStats[0].health.currentHealth, equals(100));
        expect(playerStats[1].health.currentHealth, equals(80));
      });

      test('turn with empty player stats list', () {
        final testCards = _generateTestCards(1);
        final enemyCards = CardPileModel(cards: testCards);
        final playerStats = <PlayerStatsModel>[];

        final enemyTurnArea = EnemyTurnCoordinator(
          enemyCards: enemyCards,
          playersModel: PlayersModel(players: playerStats),
          gameStateService: DefaultGameStateService(GameStateManager()),
        );

        // Should not throw and should complete turn
        expect(() => enemyTurnArea.drawCardsFromDeck(), returnsNormally);
      });
    });

    group('GameStateManager integration', () {
      late GameStateManager gameStateManager;
      late GameStateService gameStateService;

      setUp(() {
        gameStateManager = GameStateManager();
        gameStateService = DefaultGameStateService(gameStateManager);
      });

      test('calls nextPhase when turn finishes', () {
        // Set up game state to enemyTurn phase
        gameStateManager.reset(); // waitingToDrawCards
        gameStateManager.nextPhase(); // cardsDrawn
        gameStateManager.nextPhase(); // enemyTurn
        expect(gameStateManager.currentPhase, equals(GamePhase.enemyTurn));

        final testCards = [
          CardModel(
            name: 'Basic Enemy Card',
            type: 'enemy',
            isFaceUp: false,
            effects: [
              EffectModel(
                type: EffectType.attack,
                target: EffectTarget.activePlayer,
                value: 10,
              ),
            ],
          ),
        ];

        final enemyCards = CardPileModel(cards: testCards);
        final playerStats = [_createTestPlayerStats('Player1', isActive: true)];

        final enemyTurnArea = EnemyTurnCoordinator(
          enemyCards: enemyCards,
          playersModel: PlayersModel(players: playerStats),
          gameStateService: gameStateService,
        );

        enemyTurnArea.drawCardsFromDeck();

        // Should advance to playerTurn phase after finishing enemy turn
        expect(gameStateManager.currentPhase, equals(GamePhase.playerTurn));
      });

      test('advances to next phase after turn completion', () {
        gameStateManager.reset(); // Start fresh
        gameStateManager.nextPhase(); // cardsDrawn
        gameStateManager.nextPhase(); // enemyTurn

        final testCards = [
          CardModel(
            name: 'Simple Card',
            type: 'enemy',
            effects: [
              EffectModel(
                type: EffectType.attack,
                target: EffectTarget.activePlayer,
                value: 5,
              ),
            ],
          ),
        ];

        final enemyCards = CardPileModel(cards: testCards);
        final playerStats = [_createTestPlayerStats('Player1', isActive: true)];

        final enemyTurnArea = EnemyTurnCoordinator(
          enemyCards: enemyCards,
          playersModel: PlayersModel(players: playerStats),
          gameStateService: gameStateService,
        );

        enemyTurnArea.drawCardsFromDeck();

        expect(gameStateManager.currentPhase, equals(GamePhase.playerTurn));
      });

      test('does not advance phase on incomplete turn', () {
        gameStateManager.reset();
        gameStateManager.nextPhase(); // cardsDrawn
        gameStateManager.nextPhase(); // enemyTurn

        final testCards = [
          CardModel(
            name: 'Draw Card Effect',
            type: 'enemy',
            effects: [
              EffectModel(
                type: EffectType.drawCard,
                target: EffectTarget.self,
                value: 1,
              ),
            ],
          ),
        ];

        final enemyCards = CardPileModel(cards: testCards);
        final playerStats = [_createTestPlayerStats('Player1', isActive: true)];

        final enemyTurnArea = EnemyTurnCoordinator(
          enemyCards: enemyCards,
          playersModel: PlayersModel(players: playerStats),
          gameStateService: gameStateService,
        );

        enemyTurnArea.drawCardsFromDeck();

        // Since card has drawCard effect, turn should continue
        expect(
          gameStateManager.currentPhase,
          equals(GamePhase.enemyTurn),
        ); // Should remain in enemyTurn
      });

      test('phase advances correctly with multiple card draws', () {
        gameStateManager.reset();
        gameStateManager.nextPhase(); // cardsDrawn
        gameStateManager.nextPhase(); // enemyTurn

        final testCards = [
          CardModel(
            name: 'Attack Card 1',
            type: 'enemy',
            effects: [
              EffectModel(
                type: EffectType.attack,
                target: EffectTarget.activePlayer,
                value: 10,
              ),
            ],
          ),
          CardModel(
            name: 'Attack Card 2',
            type: 'enemy',
            effects: [
              EffectModel(
                type: EffectType.attack,
                target: EffectTarget.activePlayer,
                value: 15,
              ),
            ],
          ),
        ];

        final enemyCards = CardPileModel(cards: testCards);
        final playerStats = [
          _createTestPlayerStats('Player1', isActive: true, health: 100),
        ];

        final enemyTurnArea = EnemyTurnCoordinator(
          enemyCards: enemyCards,
          playersModel: PlayersModel(players: playerStats),
          gameStateService: gameStateService,
        );

        // Draw first card - should finish turn and advance phase
        final initialHealth = playerStats[0].health.currentHealth;
        enemyTurnArea.drawCardsFromDeck();
        expect(gameStateManager.currentPhase, equals(GamePhase.playerTurn));

        final healthAfterFirstCard = playerStats[0].health.currentHealth;
        final firstDamage = initialHealth - healthAfterFirstCard;
        expect(
          [10, 15],
          contains(firstDamage),
        ); // Cards shuffled, could be either damage value

        // Reset turn to simulate natural game flow before next enemy turn
        enemyTurnArea.resetTurn();

        // Draw second card - this will draw another card and advance phase again
        enemyTurnArea.drawCardsFromDeck();
        expect(
          gameStateManager.currentPhase,
          equals(GamePhase.waitingToDrawCards),
        ); // nextPhase from playerTurn goes to waitingToDrawCards

        final finalHealth = playerStats[0].health.currentHealth;
        final totalDamage = initialHealth - finalHealth;
        expect(totalDamage, equals(25)); // Total damage should be 10 + 15 = 25
      });
    });
  });

  group('turn management', () {
    test('resetTurn sets _turnFinished to false', () {
      // Create a card without drawCard effect so turn will finish
      final card = CardModel(
        name: 'Test Card',
        type: 'enemy',
        isFaceUp: false,
        effects: [
          EffectModel(
            type: EffectType.attack,
            target: EffectTarget.activePlayer,
            value: 10,
          ),
        ],
      );

      final cardPile = CardPileModel(cards: [card]);
      final players = [_createTestPlayerStats('TestPlayer')];
      final playersModel = PlayersModel(players: players);
      final gameStateService = DefaultGameStateService(GameStateManager());

      final enemyTurnArea = EnemyTurnCoordinator(
        enemyCards: cardPile,
        playersModel: playersModel,
        gameStateService: gameStateService,
      );

      // Draw a card to finish the turn (since card has no drawCard effect)
      enemyTurnArea.drawCardsFromDeck();

      // Reset the turn
      enemyTurnArea.resetTurn();

      // Verify that we can draw another card (turn is not finished)
      final initialPlayedCardsCount = enemyTurnArea.playedCards.allCards.length;

      // Add another card to test with
      final anotherCard = CardModel(
        name: 'Another Card',
        type: 'enemy',
        isFaceUp: false,
        effects: [
          EffectModel(
            type: EffectType.attack,
            target: EffectTarget.activePlayer,
            value: 5,
          ),
        ],
      );
      enemyTurnArea.enemyCards.addCard(anotherCard);

      enemyTurnArea.drawCardsFromDeck(); // This should work if turn was reset

      // If turn was properly reset, we should have added another card
      expect(
        enemyTurnArea.playedCards.allCards.length,
        equals(initialPlayedCardsCount + 1),
      );
    });
  });
}
