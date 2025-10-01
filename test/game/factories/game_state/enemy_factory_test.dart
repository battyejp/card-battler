import 'package:card_battler/game/config/game_configuration.dart';
import 'package:card_battler/game/factories/game_state/enemy_factory.dart';
import 'package:card_battler/game/models/card/card_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EnemyFactory', () {
    late List<CardModel> testCards;
    late GameConfiguration testConfig;

    setUp(() {
      testCards = [
        CardModel(
          name: 'Test Card 1',
          description: 'Test Description 1',
          cost: 1,
          type: CardType.enemy,
          filename: 'test_card_1.png',
          effects: [],
        ),
        CardModel(
          name: 'Test Card 2',
          description: 'Test Description 2',
          cost: 2,
          type: CardType.enemy,
          filename: 'test_card_2.png',
          effects: [],
        ),
      ];
      testConfig = const GameConfiguration(
        numberOfEnemies: 5,
        defaultHealth: 12,
      );
    });

    group('createEnemiesModel', () {
      test('creates EnemiesModel with correct number of enemies', () {
        final enemiesModel = EnemyFactory.createEnemiesModel(
          count: 5,
          enemyCards: testCards,
          config: testConfig,
        );

        expect(enemiesModel.enemies.length, equals(5));
      });

      test('creates EnemiesModel with provided deck cards', () {
        final enemiesModel = EnemyFactory.createEnemiesModel(
          count: 3,
          enemyCards: testCards,
          config: testConfig,
        );

        expect(enemiesModel.deckCards.allCards.length, equals(testCards.length));
        expect(identical(enemiesModel.deckCards.allCards, testCards), isTrue);
      });

      test('creates EnemiesModel with empty played cards', () {
        final enemiesModel = EnemyFactory.createEnemiesModel(
          count: 3,
          enemyCards: testCards,
          config: testConfig,
        );

        expect(enemiesModel.playedCards.allCards, isEmpty);
      });

      test('enemies in model have correct health', () {
        final enemiesModel = EnemyFactory.createEnemiesModel(
          count: 3,
          enemyCards: testCards,
          config: testConfig,
        );

        for (final enemy in enemiesModel.enemies) {
          expect(enemy.healthModel.currentHealth, equals(testConfig.defaultHealth));
          expect(enemy.healthModel.maxHealth, equals(testConfig.defaultHealth));
        }
      });
    });

    group('createEnemies', () {
      test('creates the specified number of enemies', () {
        final enemies = EnemyFactory.createEnemies(
          count: 4,
          config: testConfig,
        );

        expect(enemies.length, equals(4));
      });

      test('creates enemies with correct names', () {
        final enemies = EnemyFactory.createEnemies(
          count: 3,
          config: testConfig,
        );

        expect(enemies[0].name, equals('Enemy 1'));
        expect(enemies[1].name, equals('Enemy 2'));
        expect(enemies[2].name, equals('Enemy 3'));
      });

      test('creates enemies with correct health values', () {
        final enemies = EnemyFactory.createEnemies(
          count: 2,
          config: testConfig,
        );

        for (final enemy in enemies) {
          expect(enemy.healthModel.currentHealth, equals(testConfig.defaultHealth));
          expect(enemy.healthModel.maxHealth, equals(testConfig.defaultHealth));
        }
      });
    });

    group('createEnemy', () {
      test('creates enemy with correct index-based name', () {
        final enemy = EnemyFactory.createEnemy(
          index: 3,
          config: testConfig,
        );

        expect(enemy.name, equals('Enemy 4'));
      });

      test('creates enemy with correct health', () {
        final enemy = EnemyFactory.createEnemy(
          index: 0,
          config: testConfig,
        );

        expect(enemy.healthModel.currentHealth, equals(testConfig.defaultHealth));
        expect(enemy.healthModel.maxHealth, equals(testConfig.defaultHealth));
      });
    });
  });
}
