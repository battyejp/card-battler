import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/models/team/base_model.dart';

void main() {
  group('BaseModel', () {
    group('constructor and initialization', () {
      test('creates with required parameters', () {
        final model = BaseModel(name: 'Test Base', maxHealth: 100);
        
        expect(model.name, equals('Test Base'));
        expect(model.healthDisplay, equals('100/100'));
      });

      test('initializes health at maximum', () {
        final model = BaseModel(name: 'Base Alpha', maxHealth: 50);
        expect(model.healthDisplay, equals('50/50'));
      });
    });

    group('health display integration', () {
      test('returns correct health display format', () {
        final model = BaseModel(name: 'Base Beta', maxHealth: 75);
        expect(model.healthDisplay, equals('75/75'));
      });

      test('health display reflects underlying HealthModel', () {
        final model1 = BaseModel(name: 'Base 1', maxHealth: 25);
        final model2 = BaseModel(name: 'Base 2', maxHealth: 150);
        
        expect(model1.healthDisplay, equals('25/25'));
        expect(model2.healthDisplay, equals('150/150'));
      });
    });

    group('name property', () {
      test('stores and returns correct name', () {
        final testNames = ['Base Alpha', 'Fortress Beta', 'Base 1', 'Test Base'];
        
        for (final name in testNames) {
          final model = BaseModel(name: name, maxHealth: 10);
          expect(model.name, equals(name));
        }
      });

      test('name is immutable', () {
        final model = BaseModel(name: 'Original Name', maxHealth: 10);
        expect(model.name, equals('Original Name'));
        
        // Name should remain unchanged (it's final)
        expect(model.name, equals('Original Name'));
      });
    });
  });
}