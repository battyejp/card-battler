import 'package:card_battler/game/models/enemy/enemies_model.dart';
import 'package:card_battler/game/models/enemy/enemy_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EnemiesModel', () {
    group('constructor and initialization', () {
      test('creates with required totalEnemies parameter', () {
        final model = EnemiesModel(totalEnemies: 3);

        expect(model.allEnemies.length, equals(3));
      });

      test('creates enemies with default max health', () {
        final model = EnemiesModel(totalEnemies: 2);

        for (final enemy in model.allEnemies) {
          expect(enemy.healthDisplay, equals('5/5')); // Default enemyMaxHealth is 5
        }
      });

      test('creates enemies with custom max health', () {
        final model = EnemiesModel(totalEnemies: 3, enemyMaxHealth: 100);

        for (final enemy in model.allEnemies) {
          expect(enemy.healthDisplay, equals('100/100'));
        }
      });

      test('assigns correct names to enemies', () {
        final model = EnemiesModel(totalEnemies: 4, enemyMaxHealth: 10);

        expect(model.allEnemies[0].name, equals('Enemy 1'));
        expect(model.allEnemies[1].name, equals('Enemy 2'));
        expect(model.allEnemies[2].name, equals('Enemy 3'));
        expect(model.allEnemies[3].name, equals('Enemy 4'));
      });
    });

    group('display text', () {
      test('shows correct enemy number and total for initial state', () {
        final testCases = [
          {'totalEnemies': 1, 'expected': '0 enemies left'},
          {'totalEnemies': 2, 'expected': '0 enemies left'},
          {'totalEnemies': 5, 'expected': '2 enemies left'},
        ];

        for (final testCase in testCases) {
          final model = EnemiesModel(totalEnemies: testCase['totalEnemies'] as int);
          expect(model.displayText, equals(testCase['expected']));
        }
      });
    });

    group('all enemies access', () {
      test('returns unmodifiable list of all enemies', () {
        final model = EnemiesModel(totalEnemies: 3, enemyMaxHealth: 25);
        final enemies = model.allEnemies;

        expect(enemies.length, equals(3));
        expect(enemies[0].name, equals('Enemy 1'));
        expect(enemies[1].name, equals('Enemy 2'));
        expect(enemies[2].name, equals('Enemy 3'));

        for (final enemy in enemies) {
          expect(enemy.healthDisplay, equals('25/25'));
        }
      });

      test('returned list is unmodifiable', () {
        final model = EnemiesModel(totalEnemies: 2);
        final enemies = model.allEnemies;

        expect(() => enemies.add(EnemyModel(name: 'Extra', maxHealth: 10)),
            throwsUnsupportedError);
        expect(() => enemies.removeAt(0), throwsUnsupportedError);
        expect(() => enemies.clear(), throwsUnsupportedError);
      });

      test('multiple calls return same data', () {
        final model = EnemiesModel(totalEnemies: 4, enemyMaxHealth: 50);
        final enemies1 = model.allEnemies;
        final enemies2 = model.allEnemies;

        expect(enemies1.length, equals(enemies2.length));
        for (int i = 0; i < enemies1.length; i++) {
          expect(enemies1[i].name, equals(enemies2[i].name));
          expect(enemies1[i].healthDisplay, equals(enemies2[i].healthDisplay));
        }
      });
    });
  });
}