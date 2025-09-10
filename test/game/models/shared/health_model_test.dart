import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game_legacy/models/shared/health_model.dart';

void main() {
  group('Health', () {
    group('constructor and initialization', () {
      test('creates with required parameters', () {
        final model = HealthModel(maxHealth: 100);
        
        expect(model.maxHealth, equals(100));
        expect(model.currentHealth, equals(100));
      });

      test('initializes current health to max health', () {
        final model = HealthModel(maxHealth: 50);
        expect(model.currentHealth, equals(50));
      });

      test('uses default max health from GameConstants', () {
        final model = HealthModel(maxHealth: 10);
        expect(model.maxHealth, equals(10));
        expect(model.currentHealth, equals(10));
      });
    });

    group('health management', () {
      final testCases = [
        {'description': 'reduces health correctly', 'changes': [-20], 'expected': 80},
        {'description': 'increases health correctly', 'changes': [-30, 10], 'expected': 80},
        {'description': 'clamps health to maximum', 'changes': [50], 'expected': 100},
        {'description': 'clamps health to zero', 'changes': [-150], 'expected': 0},
        {'description': 'handles multiple health changes', 'changes': [-25, -25, -25], 'expected': 25},
        {'description': 'handles zero delta change', 'changes': [0], 'expected': 100},
      ];

      for (final testCase in testCases) {
        test(testCase['description'] as String, () {
          final model = HealthModel(maxHealth: 100);
          final changes = testCase['changes'] as List<int>;
          
          for (final change in changes) {
            model.changeHealth(change);
          }
          
          expect(model.currentHealth, equals(testCase['expected']));
        });
      }
    });

    group('health status helpers', () {
      test('healthDisplay returns correct format', () {
        final model = HealthModel(maxHealth: 100);
        expect(model.healthDisplay, equals('100/100'));
        
        model.changeHealth(-25);
        expect(model.healthDisplay, equals('75/100'));
      });
    });
  });
}