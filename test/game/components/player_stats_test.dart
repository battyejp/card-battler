import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/player_stats.dart';
import 'package:card_battler/game/game_constants.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  group('PlayerStats', () {
    group('constructor and initialization', () {
      test('creates with required parameters', () {
        final stats = PlayerStats(name: 'Test Player', maxHealth: 100);
        
        expect(stats.name, equals('Test Player'));
        expect(stats.maxHealth, equals(100));
        expect(stats.currentHealth, equals(100));
      });

      test('initializes current health to max health', () {
        final stats = PlayerStats(name: 'Player', maxHealth: 50);
        expect(stats.currentHealth, equals(50));
      });

      test('uses default max health from GameConstants', () {
        final stats = PlayerStats(name: 'Default Player');
        expect(stats.maxHealth, equals(GameConstants.defaultMaxHealth));
        expect(stats.currentHealth, equals(GameConstants.defaultMaxHealth));
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
          final stats = PlayerStats(name: 'Test Player', maxHealth: 100);
          final changes = testCase['changes'] as List<int>;
          
          for (final change in changes) {
            stats.changeHealth(change);
          }
          
          expect(stats.currentHealth, equals(testCase['expected']));
        });
      }
    });

    group('component behavior', () {
      final testCases = [
        {'size': Vector2(100, 100), 'pos': Vector2(10, 20)},
        {'size': Vector2(200, 200), 'pos': Vector2(0, 0)},
      ];

      for (final testCase in testCases) {
        testWithFlameGame('size and position for size ${testCase['size']} pos ${testCase['pos']}', (game) async {
          final stats = PlayerStats(name: 'Test Player', maxHealth: 100)
            ..size = testCase['size'] as Vector2
            ..position = testCase['pos'] as Vector2;

          await game.ensureAdd(stats);

          expect(game.children.contains(stats), isTrue);
          expect(stats.size, testCase['size']);
          expect(stats.position, testCase['pos']);
        });
      }

      testWithFlameGame('adds text component on load', (game) async {
        final stats = PlayerStats(name: 'Test Player', maxHealth: 100);
        await game.ensureAdd(stats);
        
        expect(stats.children.whereType<TextComponent>().length, equals(1));
        
        final textComponent = stats.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('Test Player: 100/100'));
        expect(textComponent.position, equals(Vector2(10, 10)));
      });
    });
  });
}
