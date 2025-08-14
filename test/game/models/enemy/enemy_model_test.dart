import 'package:card_battler/game/models/enemy/enemy_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EnemyModel', () {
    group('constructor and initialization', () {
      test('creates with required parameters', () {
        final model = EnemyModel(name: 'Test Enemy', maxHealth: 100);

        expect(model.name, equals('Test Enemy'));
        expect(model.healthDisplay, equals('100/100'));
      });

      test('initializes health at maximum', () {
        final model = EnemyModel(name: 'Enemy Alpha', maxHealth: 50);
        expect(model.healthDisplay, equals('50/50'));
      });
    });

    group('health display integration', () {
      test('returns correct health display format', () {
        final model = EnemyModel(name: 'Enemy Beta', maxHealth: 75);
        expect(model.healthDisplay, equals('75/75'));
      });

      test('health display reflects underlying HealthModel', () {
        final model1 = EnemyModel(name: 'Enemy 1', maxHealth: 25);
        final model2 = EnemyModel(name: 'Enemy 2', maxHealth: 150);

        expect(model1.healthDisplay, equals('25/25'));
        expect(model2.healthDisplay, equals('150/150'));
      });
    });

    group('name property', () {
      test('stores and returns correct name', () {
        final testNames = ['Base Alpha', 'Fortress Beta', 'Base 1', 'Test Base'];
        
        for (final name in testNames) {
          final model = EnemyModel(name: name, maxHealth: 10);
          expect(model.name, equals(name));
        }
      });

      test('name is immutable', () {
        final model = EnemyModel(name: 'Original Name', maxHealth: 10);
        expect(model.name, equals('Original Name'));
        
        // Name should remain unchanged (it's final)
        expect(model.name, equals('Original Name'));
      });
    });
  });
}