import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/models/player_stats_model.dart';
import 'package:card_battler/game/game_constants.dart';

void main() {
  group('PlayerStatsModel', () {
    group('constructor and initialization', () {
      test('creates with required parameters', () {
        final model = PlayerStatsModel(name: 'Test Player', maxHealth: 100);
        
        expect(model.name, equals('Test Player'));
        expect(model.maxHealth, equals(100));
        expect(model.currentHealth, equals(100));
      });

      test('initializes current health to max health', () {
        final model = PlayerStatsModel(name: 'Player', maxHealth: 50);
        expect(model.currentHealth, equals(50));
      });

      test('uses default max health from GameConstants', () {
        final model = PlayerStatsModel(name: 'Default Player');
        expect(model.maxHealth, equals(GameConstants.defaultMaxHealth));
        expect(model.currentHealth, equals(GameConstants.defaultMaxHealth));
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
          final model = PlayerStatsModel(name: 'Test Player', maxHealth: 100);
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
        final model = PlayerStatsModel(name: 'Test Player', maxHealth: 100);
        expect(model.healthDisplay, equals('Test Player: 100/100'));
        
        model.changeHealth(-25);
        expect(model.healthDisplay, equals('Test Player: 75/100'));
      });
    });
  });
}