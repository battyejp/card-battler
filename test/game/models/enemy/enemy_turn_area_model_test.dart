import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/models/enemy/enemy_turn_area_model.dart';
import 'package:card_battler/game/models/shared/card_pile_model.dart';
import 'package:card_battler/game/models/team/player_stats_model.dart';
import 'package:card_battler/game/models/team/players_model.dart';
import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/services/game_state_manager.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/services/game_state_service.dart';

List<CardModel> _generateTestCards(int count) {
  return List.generate(count, (index) => CardModel(
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
  ));
}

PlayerStatsModel _createTestPlayerStats(String name, {bool isActive = false, int health = 100}) {
  final healthModel = HealthModel(maxHealth: health);
  return PlayerStatsModel(
    name: name,
    health: healthModel,
    isActive: isActive,
  );
}

void main() {
  group('EnemyTurnAreaModel', () {
    group('constructor and initialization', () {
      test('creates with required parameters', () {
        final enemyCards = CardPileModel(cards: _generateTestCards(5));
        final playerStats = [_createTestPlayerStats('Player1', isActive: true)];
        
        final enemyTurnArea = EnemyTurnAreaModel(
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
        
        final enemyTurnArea = EnemyTurnAreaModel(
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
        
        final enemyTurnArea = EnemyTurnAreaModel(
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
        
        final enemyTurnArea = EnemyTurnAreaModel(
          enemyCards: enemyCards,
          playersModel: PlayersModel(players: playerStats),
          gameStateService: DefaultGameStateService(GameStateManager()),
        );

        final initialEnemyCount = enemyTurnArea.enemyCards.allCards.length;
        final initialPlayedCount = enemyTurnArea.playedCards.allCards.length;

        enemyTurnArea.drawCardsFromDeck();

        expect(enemyTurnArea.enemyCards.allCards.length, equals(initialEnemyCount - 1));
        expect(enemyTurnArea.playedCards.allCards.length, equals(initialPlayedCount + 1));
      });

      test('sets drawn card to face up', () {
        final testCards = _generateTestCards(1);
        final enemyCards = CardPileModel(cards: testCards);
        final playerStats = [_createTestPlayerStats('Player1', isActive: true)];
        
        final enemyTurnArea = EnemyTurnAreaModel(
          enemyCards: enemyCards,
          playersModel: PlayersModel(players: playerStats),
          gameStateService: DefaultGameStateService(GameStateManager()),
        );

        // Verify card starts face down
        expect(testCards[0].isFaceUp, isFalse);

        enemyTurnArea.drawCardsFromDeck();

        // Verify played card is now face up
        expect(enemyTurnArea.playedCards.allCards.first.isFaceUp, isTrue);
      });
    });

    group('updatePlayersStats functionality', () {
      test('applies damage to active player only', () {
        final activePlayer = _createTestPlayerStats('ActivePlayer', isActive: true, health: 100);
        final inactivePlayer = _createTestPlayerStats('InactivePlayer', isActive: false, health: 100);
        final playerStats = [activePlayer, inactivePlayer];
        
        final enemyCards = CardPileModel.empty();
        final enemyTurnArea = EnemyTurnAreaModel(
          enemyCards: enemyCards,
          playersModel: PlayersModel(players: playerStats),
          gameStateService: DefaultGameStateService(GameStateManager()),
        );

        final damageCard = CardModel(
          name: 'Damage Card',
          type: 'enemy',
          effects: [
            EffectModel(
              type: EffectType.attack,
              target: EffectTarget.activePlayer,
              value: 25,
            ),
          ],
        );

        enemyTurnArea.updatePlayersStats(damageCard);

        expect(activePlayer.health.currentHealth, equals(75)); // 100 - 25
        expect(inactivePlayer.health.currentHealth, equals(100)); // unchanged
      });

      test('handles multiple active players', () {
        final activePlayer1 = _createTestPlayerStats('ActivePlayer1', isActive: true, health: 100);
        final activePlayer2 = _createTestPlayerStats('ActivePlayer2', isActive: true, health: 80);
        final inactivePlayer = _createTestPlayerStats('InactivePlayer', isActive: false, health: 90);
        final playerStats = [activePlayer1, activePlayer2, inactivePlayer];
        
        final enemyCards = CardPileModel.empty();
        final enemyTurnArea = EnemyTurnAreaModel(
          enemyCards: enemyCards,
          playersModel: PlayersModel(players: playerStats),
          gameStateService: DefaultGameStateService(GameStateManager()),
        );

        final damageCard = CardModel(
          name: 'AOE Damage Card',
          type: 'enemy',
          effects: [
            EffectModel(
              type: EffectType.attack,
              target: EffectTarget.activePlayer,
              value: 15,
            ),
          ],
        );

        enemyTurnArea.updatePlayersStats(damageCard);

        expect(activePlayer1.health.currentHealth, equals(85)); // 100 - 15
        expect(activePlayer2.health.currentHealth, equals(65)); // 80 - 15
        expect(inactivePlayer.health.currentHealth, equals(90)); // unchanged
      });

      test('handles cards with multiple effects', () {
        final activePlayer = _createTestPlayerStats('ActivePlayer', isActive: true, health: 100);
        final playerStats = [activePlayer];
        
        final enemyCards = CardPileModel.empty();
        final enemyTurnArea = EnemyTurnAreaModel(
          enemyCards: enemyCards,
          playersModel: PlayersModel(players: playerStats),
          gameStateService: DefaultGameStateService(GameStateManager()),
        );

        final multiEffectCard = CardModel(
          name: 'Multi Effect Card',
          type: 'enemy',
          effects: [
            EffectModel(
              type: EffectType.attack,
              target: EffectTarget.activePlayer,
              value: 10,
            ),
            EffectModel(
              type: EffectType.attack,
              target: EffectTarget.activePlayer,
              value: 15,
            ),
          ],
        );

        enemyTurnArea.updatePlayersStats(multiEffectCard);

        expect(activePlayer.health.currentHealth, equals(75)); // 100 - 10 - 15
      });

      test('ignores non-damage effects for now', () {
        final activePlayer = _createTestPlayerStats('ActivePlayer', isActive: true, health: 100);
        final playerStats = [activePlayer];
        
        final enemyCards = CardPileModel.empty();
        final enemyTurnArea = EnemyTurnAreaModel(
          enemyCards: enemyCards,
          playersModel: PlayersModel(players: playerStats),
          gameStateService: DefaultGameStateService(GameStateManager()),
        );

        final drawCard = CardModel(
          name: 'Draw Card',
          type: 'enemy',
          effects: [
            EffectModel(
              type: EffectType.drawCard,
              target: EffectTarget.activePlayer,
              value: 2,
            ),
          ],
        );

        enemyTurnArea.updatePlayersStats(drawCard);

        // Health should remain unchanged since drawCard effects are not implemented
        expect(activePlayer.health.currentHealth, equals(100));
      });

      test('applies damage to all players with allPlayers target', () {
        final activePlayer = _createTestPlayerStats('ActivePlayer', isActive: true, health: 100);
        final playerStats = [activePlayer];
        
        final enemyCards = CardPileModel.empty();
        final enemyTurnArea = EnemyTurnAreaModel(
          enemyCards: enemyCards,
          playersModel: PlayersModel(players: playerStats),
          gameStateService: DefaultGameStateService(GameStateManager()),
        );

        final allPlayersCard = CardModel(
          name: 'All Players Damage',
          type: 'enemy',
          effects: [
            EffectModel(
              type: EffectType.attack,
              target: EffectTarget.allPlayers,
              value: 20,
            ),
          ],
        );

        enemyTurnArea.updatePlayersStats(allPlayersCard);

        // Health should be reduced by 20 since allPlayers target applies damage to all players
        expect(activePlayer.health.currentHealth, equals(80));
      });

      test('handles card with no effects', () {
        final activePlayer = _createTestPlayerStats('ActivePlayer', isActive: true, health: 100);
        final playerStats = [activePlayer];
        
        final enemyCards = CardPileModel.empty();
        final enemyTurnArea = EnemyTurnAreaModel(
          enemyCards: enemyCards,
          playersModel: PlayersModel(players: playerStats),
          gameStateService: DefaultGameStateService(GameStateManager()),
        );

        final noEffectCard = CardModel(
          name: 'No Effect Card',
          type: 'enemy',
          effects: [],
        );

        enemyTurnArea.updatePlayersStats(noEffectCard);

        expect(activePlayer.health.currentHealth, equals(100)); // unchanged
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
        final activePlayer = _createTestPlayerStats('Hero', isActive: true, health: 100);
        final playerStats = [activePlayer];
        
        final enemyTurnArea = EnemyTurnAreaModel(
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
        expect(enemyTurnArea.playedCards.allCards.first.name, equals('Fireball'));
        expect(activePlayer.health.currentHealth, equals(70)); // 100 - 30
      });

      test('turn with no active players', () {
        final testCards = _generateTestCards(1);
        final enemyCards = CardPileModel(cards: testCards);
        final playerStats = [
          _createTestPlayerStats('Player1', isActive: false, health: 100),
          _createTestPlayerStats('Player2', isActive: false, health: 80),
        ];
        
        final enemyTurnArea = EnemyTurnAreaModel(
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
        
        final enemyTurnArea = EnemyTurnAreaModel(
          enemyCards: enemyCards,
          playersModel: PlayersModel(players: playerStats),
          gameStateService: DefaultGameStateService(GameStateManager()),
        );

        // Should not throw and should complete turn
        expect(() => enemyTurnArea.drawCardsFromDeck(), returnsNormally);
      });
    });

    group('edge cases and error handling', () {
      test('handles zero damage', () {
        final activePlayer = _createTestPlayerStats('Player', isActive: true, health: 50);
        final playerStats = [activePlayer];
        
        final enemyCards = CardPileModel.empty();
        final enemyTurnArea = EnemyTurnAreaModel(
          enemyCards: enemyCards,
          playersModel: PlayersModel(players: playerStats),
          gameStateService: DefaultGameStateService(GameStateManager()),
        );

        final zeroDamageCard = CardModel(
          name: 'Weak Card',
          type: 'enemy',
          effects: [
            EffectModel(
              type: EffectType.attack,
              target: EffectTarget.activePlayer,
              value: 0,
            ),
          ],
        );

        enemyTurnArea.updatePlayersStats(zeroDamageCard);

        expect(activePlayer.health.currentHealth, equals(50)); // unchanged
      });

      test('handles negative damage (healing)', () {
        final activePlayer = _createTestPlayerStats('ActivePlayer', isActive: true, health: 100);
        final playerStats = [activePlayer];
        
        // Damage the player first so they can be healed
        activePlayer.health.changeHealth(-30); // Now at 70/100
        
        final enemyCards = CardPileModel.empty();
        final enemyTurnArea = EnemyTurnAreaModel(
          enemyCards: enemyCards,
          playersModel: PlayersModel(players: playerStats),
          gameStateService: DefaultGameStateService(GameStateManager()),
        );

        final healingCard = CardModel(
          name: 'Healing Card',
          type: 'enemy',
          effects: [
            EffectModel(
              type: EffectType.attack,
              target: EffectTarget.activePlayer,
              value: -20, // negative damage = healing
            ),
          ],
        );

        enemyTurnArea.updatePlayersStats(healingCard);

        expect(activePlayer.health.currentHealth, equals(90)); // 70 + 20
      });

      test('handles extremely high damage values', () {
        final activePlayer = _createTestPlayerStats('Player', isActive: true, health: 100);
        final playerStats = [activePlayer];
        
        final enemyCards = CardPileModel.empty();
        final enemyTurnArea = EnemyTurnAreaModel(
          enemyCards: enemyCards,
          playersModel: PlayersModel(players: playerStats),
          gameStateService: DefaultGameStateService(GameStateManager()),
        );

        final overkillCard = CardModel(
          name: 'Overkill Card',
          type: 'enemy',
          effects: [
            EffectModel(
              type: EffectType.attack,
              target: EffectTarget.activePlayer,
              value: 9999,
            ),
          ],
        );

        enemyTurnArea.updatePlayersStats(overkillCard);

        // Should result in 0 health (death) - health model clamps to 0
        expect(activePlayer.health.currentHealth, equals(0)); // clamped to 0, not negative
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
        
        final enemyTurnArea = EnemyTurnAreaModel(
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
        
        final enemyTurnArea = EnemyTurnAreaModel(
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
        
        final enemyTurnArea = EnemyTurnAreaModel(
          enemyCards: enemyCards,
          playersModel: PlayersModel(players: playerStats),
          gameStateService: gameStateService,
        );

        enemyTurnArea.drawCardsFromDeck();

        // Since card has drawCard effect, turn should continue
        expect(gameStateManager.currentPhase, equals(GamePhase.enemyTurn)); // Should remain in enemyTurn
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
        final playerStats = [_createTestPlayerStats('Player1', isActive: true, health: 100)];
        
        final enemyTurnArea = EnemyTurnAreaModel(
          enemyCards: enemyCards,
          playersModel: PlayersModel(players: playerStats),
          gameStateService: gameStateService,
        );

        // Draw first card - should finish turn and advance phase
        enemyTurnArea.drawCardsFromDeck();
        expect(gameStateManager.currentPhase, equals(GamePhase.playerTurn));
        expect(playerStats[0].health.currentHealth, equals(90)); // 100 - 10

        // Draw second card - this will draw another card and advance phase again
        enemyTurnArea.drawCardsFromDeck();
        expect(gameStateManager.currentPhase, equals(GamePhase.waitingToDrawCards)); // nextPhase from playerTurn goes to waitingToDrawCards
        expect(playerStats[0].health.currentHealth, equals(75)); // 90 - 15
      });
    });
  });
}