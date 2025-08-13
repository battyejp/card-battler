import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/team.dart';
import 'package:card_battler/game/components/player_stats.dart';
import 'package:card_battler/game/components/base.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  final testCases = [
    {
      'teamSize': Vector2(200, 300),
      'playerStats': [
        {'size': Vector2(200, 45), 'pos': Vector2(0, 0)},
        {'size': Vector2(200, 45), 'pos': Vector2(0, 45)},
        {'size': Vector2(200, 45), 'pos': Vector2(0, 90)},
      ],
      'base': {'size': Vector2(200, 165), 'pos': Vector2(0, 135)},
    },
    {
      'teamSize': Vector2(400, 600),
      'playerStats': [
        {'size': Vector2(400, 90), 'pos': Vector2(0, 0)},
        {'size': Vector2(400, 90), 'pos': Vector2(0, 90)},
        {'size': Vector2(400, 90), 'pos': Vector2(0, 180)},
      ],
      'base': {'size': Vector2(400, 330), 'pos': Vector2(0, 270)},
    },
  ];
  for (final testCase in testCases) {
    testWithFlameGame('Team children sizes and positions for team size ${testCase['teamSize']}', (game) async {
      final team = Team()..size = testCase['teamSize'] as Vector2;

      await game.ensureAdd(team);

      final stats = team.children.whereType<PlayerStats>().toList();
      final base = team.children.whereType<Base>().first;
      expect(stats.length, 3);
      expect(team.children.whereType<Base>().length, 1);
      final playerStats = testCase['playerStats'] as List<Map<String, Vector2>>;
      for (int i = 0; i < 3; i++) {
        expect(stats[i].size, playerStats[i]['size']);
        expect(stats[i].position, playerStats[i]['pos']);
      }
      final baseCase = testCase['base'] as Map<String, Vector2>;
      expect(base.size, baseCase['size']);
      expect(base.position, baseCase['pos']);
    });
  }
}
