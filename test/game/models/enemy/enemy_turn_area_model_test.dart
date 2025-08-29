import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/models/enemy/enemy_turn_area_model.dart';
import 'package:card_battler/game/models/shared/card_pile_model.dart';
import 'package:card_battler/game/models/team/player_stats_model.dart';
import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';

List<CardModel> _generateTestCards(int count) {
  return List.generate(count, (index) => CardModel(
    name: 'Enemy Card $index',
    type: 'enemy',
    isFaceUp: false,
    abilities: [
      AbilityModel(
        type: AbilityType.damage,
        target: AbilityTarget.activePlayer,
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
          playerStats: playerStats,
        );

        expect(enemyTurnArea.enemyCards, equals(enemyCards));
        expect(enemyTurnArea.playerStats, equals(playerStats));
        expect(enemyTurnArea.playedCards.hasNoCards, isTrue);
        expect(enemyTurnArea.turnFinished, isFalse);
      });

      test('initializes empty played cards pile', () {
        final enemyCards = CardPileModel(cards: _generateTestCards(3));
        final playerStats = [_createTestPlayerStats('Player1')];
        
        final enemyTurnArea = EnemyTurnAreaModel(
          enemyCards: enemyCards,
          playerStats: playerStats,
        );

        expect(enemyTurnArea.playedCards.hasNoCards, isTrue);
        expect(enemyTurnArea.playedCards.allCards.length, equals(0));
      });

      test('initializes turnFinished as false', () {
        final enemyCards = CardPileModel(cards: _generateTestCards(2));
        final playerStats = [_createTestPlayerStats('Player1')];
        
        final enemyTurnArea = EnemyTurnAreaModel(
          enemyCards: enemyCards,
          playerStats: playerStats,
        );

        expect(enemyTurnArea.turnFinished, isFalse);
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
          playerStats: playerStats,
        );

        expect(enemyTurnArea.playerStats.length, equals(3));
        expect(enemyTurnArea.playerStats[0].name, equals('Player1'));
        expect(enemyTurnArea.playerStats[0].isActive, isTrue);
        expect(enemyTurnArea.playerStats[1].isActive, isFalse);
      });
    });

    group('drawCardsFromDeck functionality', () {
      test('draws card from enemy deck and adds to played cards', () {
        final testCards = _generateTestCards(3);
        final enemyCards = CardPileModel(cards: testCards);
        final playerStats = [_createTestPlayerStats('Player1', isActive: true)];
        
        final enemyTurnArea = EnemyTurnAreaModel(
          enemyCards: enemyCards,
          playerStats: playerStats,
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
          playerStats: playerStats,
        );

        // Verify card starts face down
        expect(testCards[0].isFaceUp, isFalse);

        enemyTurnArea.drawCardsFromDeck();

        // Verify played card is now face up
        expect(enemyTurnArea.playedCards.allCards.first.isFaceUp, isTrue);
      });

      test('sets turnFinished to true after drawing', () {
        final enemyCards = CardPileModel(cards: _generateTestCards(2));
        final playerStats = [_createTestPlayerStats('Player1', isActive: true)];
        
        final enemyTurnArea = EnemyTurnAreaModel(
          enemyCards: enemyCards,
          playerStats: playerStats,
        );

        expect(enemyTurnArea.turnFinished, isFalse);

        enemyTurnArea.drawCardsFromDeck();

        expect(enemyTurnArea.turnFinished, isTrue);
      });

      test('does nothing if turn is already finished', () {
        final enemyCards = CardPileModel(cards: _generateTestCards(3));
        final playerStats = [_createTestPlayerStats('Player1', isActive: true)];
        
        final enemyTurnArea = EnemyTurnAreaModel(
          enemyCards: enemyCards,
          playerStats: playerStats,
        );

        // First draw
        enemyTurnArea.drawCardsFromDeck();
        expect(enemyTurnArea.turnFinished, isTrue);
        
        final cardsAfterFirstDraw = enemyTurnArea.playedCards.allCards.length;
        final enemyCardsAfterFirstDraw = enemyTurnArea.enemyCards.allCards.length;

        // Attempt second draw
        enemyTurnArea.drawCardsFromDeck();

        // Should remain unchanged
        expect(enemyTurnArea.playedCards.allCards.length, equals(cardsAfterFirstDraw));
        expect(enemyTurnArea.enemyCards.allCards.length, equals(enemyCardsAfterFirstDraw));
      });

      test('handles empty enemy deck gracefully', () {
        final enemyCards = CardPileModel.empty();
        final playerStats = [_createTestPlayerStats('Player1', isActive: true)];
        
        final enemyTurnArea = EnemyTurnAreaModel(
          enemyCards: enemyCards,
          playerStats: playerStats,
        );

        enemyTurnArea.drawCardsFromDeck();

        expect(enemyTurnArea.playedCards.hasNoCards, isTrue);
        expect(enemyTurnArea.turnFinished, isTrue);
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
          playerStats: playerStats,
        );

        final damageCard = CardModel(
          name: 'Damage Card',
          type: 'enemy',
          abilities: [
            AbilityModel(
              type: AbilityType.damage,
              target: AbilityTarget.activePlayer,
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
          playerStats: playerStats,
        );

        final damageCard = CardModel(
          name: 'AOE Damage Card',
          type: 'enemy',
          abilities: [
            AbilityModel(
              type: AbilityType.damage,
              target: AbilityTarget.activePlayer,
              value: 15,
            ),
          ],
        );

        enemyTurnArea.updatePlayersStats(damageCard);

        expect(activePlayer1.health.currentHealth, equals(85)); // 100 - 15
        expect(activePlayer2.health.currentHealth, equals(65)); // 80 - 15
        expect(inactivePlayer.health.currentHealth, equals(90)); // unchanged
      });

      test('handles cards with multiple abilities', () {
        final activePlayer = _createTestPlayerStats('ActivePlayer', isActive: true, health: 100);
        final playerStats = [activePlayer];
        
        final enemyCards = CardPileModel.empty();
        final enemyTurnArea = EnemyTurnAreaModel(
          enemyCards: enemyCards,
          playerStats: playerStats,
        );

        final multiAbilityCard = CardModel(
          name: 'Multi Ability Card',
          type: 'enemy',
          abilities: [
            AbilityModel(
              type: AbilityType.damage,
              target: AbilityTarget.activePlayer,
              value: 10,
            ),
            AbilityModel(
              type: AbilityType.damage,
              target: AbilityTarget.activePlayer,
              value: 15,
            ),
          ],
        );

        enemyTurnArea.updatePlayersStats(multiAbilityCard);

        expect(activePlayer.health.currentHealth, equals(75)); // 100 - 10 - 15
      });

      test('ignores non-damage abilities for now', () {
        final activePlayer = _createTestPlayerStats('ActivePlayer', isActive: true, health: 100);
        final playerStats = [activePlayer];
        
        final enemyCards = CardPileModel.empty();
        final enemyTurnArea = EnemyTurnAreaModel(
          enemyCards: enemyCards,
          playerStats: playerStats,
        );

        final drawCard = CardModel(
          name: 'Draw Card',
          type: 'enemy',
          abilities: [
            AbilityModel(
              type: AbilityType.drawCard,
              target: AbilityTarget.activePlayer,
              value: 2,
            ),
          ],
        );

        enemyTurnArea.updatePlayersStats(drawCard);

        // Health should remain unchanged since drawCard abilities are not implemented
        expect(activePlayer.health.currentHealth, equals(100));
      });

      test('ignores non-activePlayer targets for now', () {
        final activePlayer = _createTestPlayerStats('ActivePlayer', isActive: true, health: 100);
        final playerStats = [activePlayer];
        
        final enemyCards = CardPileModel.empty();
        final enemyTurnArea = EnemyTurnAreaModel(
          enemyCards: enemyCards,
          playerStats: playerStats,
        );

        final allPlayersCard = CardModel(
          name: 'All Players Damage',
          type: 'enemy',
          abilities: [
            AbilityModel(
              type: AbilityType.damage,
              target: AbilityTarget.allPlayers,
              value: 20,
            ),
          ],
        );

        enemyTurnArea.updatePlayersStats(allPlayersCard);

        // Health should remain unchanged since allPlayers target is not implemented
        expect(activePlayer.health.currentHealth, equals(100));
      });

      test('handles card with no abilities', () {
        final activePlayer = _createTestPlayerStats('ActivePlayer', isActive: true, health: 100);
        final playerStats = [activePlayer];
        
        final enemyCards = CardPileModel.empty();
        final enemyTurnArea = EnemyTurnAreaModel(
          enemyCards: enemyCards,
          playerStats: playerStats,
        );

        final noAbilityCard = CardModel(
          name: 'No Ability Card',
          type: 'enemy',
          abilities: [],
        );

        enemyTurnArea.updatePlayersStats(noAbilityCard);

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
            abilities: [
              AbilityModel(
                type: AbilityType.damage,
                target: AbilityTarget.activePlayer,
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
          playerStats: playerStats,
        );

        // Verify initial state
        expect(enemyTurnArea.turnFinished, isFalse);
        expect(enemyTurnArea.playedCards.hasNoCards, isTrue);
        expect(activePlayer.health.currentHealth, equals(100));

        // Execute turn
        enemyTurnArea.drawCardsFromDeck();

        // Verify final state
        expect(enemyTurnArea.turnFinished, isTrue);
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
          playerStats: playerStats,
        );

        enemyTurnArea.drawCardsFromDeck();

        // Turn should complete but no damage should be applied
        expect(enemyTurnArea.turnFinished, isTrue);
        expect(playerStats[0].health.currentHealth, equals(100));
        expect(playerStats[1].health.currentHealth, equals(80));
      });

      test('turn with empty player stats list', () {
        final testCards = _generateTestCards(1);
        final enemyCards = CardPileModel(cards: testCards);
        final playerStats = <PlayerStatsModel>[];
        
        final enemyTurnArea = EnemyTurnAreaModel(
          enemyCards: enemyCards,
          playerStats: playerStats,
        );

        // Should not throw and should complete turn
        expect(() => enemyTurnArea.drawCardsFromDeck(), returnsNormally);
        expect(enemyTurnArea.turnFinished, isTrue);
      });
    });

    group('edge cases and error handling', () {
      test('handles zero damage', () {
        final activePlayer = _createTestPlayerStats('Player', isActive: true, health: 50);
        final playerStats = [activePlayer];
        
        final enemyCards = CardPileModel.empty();
        final enemyTurnArea = EnemyTurnAreaModel(
          enemyCards: enemyCards,
          playerStats: playerStats,
        );

        final zeroDamageCard = CardModel(
          name: 'Weak Card',
          type: 'enemy',
          abilities: [
            AbilityModel(
              type: AbilityType.damage,
              target: AbilityTarget.activePlayer,
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
          playerStats: playerStats,
        );

        final healingCard = CardModel(
          name: 'Healing Card',
          type: 'enemy',
          abilities: [
            AbilityModel(
              type: AbilityType.damage,
              target: AbilityTarget.activePlayer,
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
          playerStats: playerStats,
        );

        final overkillCard = CardModel(
          name: 'Overkill Card',
          type: 'enemy',
          abilities: [
            AbilityModel(
              type: AbilityType.damage,
              target: AbilityTarget.activePlayer,
              value: 9999,
            ),
          ],
        );

        enemyTurnArea.updatePlayersStats(overkillCard);

        // Should result in 0 health (death) - health model clamps to 0
        expect(activePlayer.health.currentHealth, equals(0)); // clamped to 0, not negative
      });
    });
  });
}