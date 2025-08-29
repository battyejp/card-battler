import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:card_battler/game/models/team/player_stats_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/team/player_stats.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  group('PlayerStats', () {
    group('component behavior', () {
      final testCases = [
        {'size': Vector2(100, 100), 'pos': Vector2(10, 20)},
        {'size': Vector2(200, 200), 'pos': Vector2(0, 0)},
      ];

      for (final testCase in testCases) {
        testWithFlameGame('size and position for size ${testCase['size']} pos ${testCase['pos']}', (game) async {
          final stats = PlayerStats(model: PlayerStatsModel(name: 'Test Player', health: HealthModel(maxHealth: 100)))
            ..size = testCase['size'] as Vector2
            ..position = testCase['pos'] as Vector2;

          await game.ensureAdd(stats);

          expect(game.children.contains(stats), isTrue);
          expect(stats.size, testCase['size']);
          expect(stats.position, testCase['pos']);
        });
      }

      testWithFlameGame('adds text component on load', (game) async {
        final stats = PlayerStats(model: PlayerStatsModel(name: 'Test Player', health: HealthModel(maxHealth: 100)));
        await game.ensureAdd(stats);
        
        expect(stats.children.whereType<TextComponent>().length, equals(1));
        
        final textComponent = stats.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('Test Player'));
        expect(textComponent.position, equals(Vector2(10, 10)));
      });
    });
  });
}
