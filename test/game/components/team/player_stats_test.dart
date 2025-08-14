import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/team/player_stats.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  group('PlayerStats', () {
    group('health management', () {
      testWithFlameGame('updates text display when health changes', (game) async {
        final stats = PlayerStats(name: 'Test Player', maxHealth: 100);
        await game.ensureAdd(stats);
        
        stats.changeHealth(-25);
        
        final textComponent = stats.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('Test Player: 75/100'));
      });
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
