import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:card_battler/game/models/team/player_stats_model.dart';
import 'package:card_battler/game/models/team/players_model.dart';
import 'package:card_battler/game/models/team/team_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/team/team.dart';
import 'package:card_battler/game/components/team/player_stats.dart';
import 'package:card_battler/game/components/team/players.dart';
import 'package:card_battler/game/components/team/bases.dart';
import 'package:card_battler/game/models/team/bases_model.dart';
import 'package:card_battler/game/models/team/base_model.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  final testCases = [
    {
      'teamSize': Vector2(200, 300),
      'playerStats': [
        {'size': Vector2(200, 50), 'pos': Vector2(0, 0)},
        {'size': Vector2(200, 50), 'pos': Vector2(0, 50)},
        {'size': Vector2(200, 50), 'pos': Vector2(0, 100)},
      ],
      'base': {'size': Vector2(200, 150), 'pos': Vector2(0, 150)},
    },
    {
      'teamSize': Vector2(400, 600),
      'playerStats': [
        {'size': Vector2(400, 100), 'pos': Vector2(0, 0)},
        {'size': Vector2(400, 100), 'pos': Vector2(0, 100)},
        {'size': Vector2(400, 100), 'pos': Vector2(0, 200)},
      ],
      'base': {'size': Vector2(400, 300), 'pos': Vector2(0, 300)},
    },
  ];
  for (final testCase in testCases) {
    testWithFlameGame('Team children sizes and positions for team size ${testCase['teamSize']}', (game) async {
      final baseList = [
        BaseModel(name: 'Base 1', maxHealth: 5),
        BaseModel(name: 'Base 2', maxHealth: 5),
        BaseModel(name: 'Base 3', maxHealth: 5),
      ];
      final basesModel = BasesModel(bases: baseList);
      final playersModel = PlayersModel(players: [
        PlayerStatsModel(name: 'Player 1', health: HealthModel(maxHealth: 100), isActive: false),
        PlayerStatsModel(name: 'Player 2', health: HealthModel(maxHealth: 100), isActive: false),
        PlayerStatsModel(name: 'Player 3', health: HealthModel(maxHealth: 100), isActive: false),
      ]);
      final teamModel = TeamModel(bases: basesModel, playersModel: playersModel);
      final team = Team(teamModel)..size = testCase['teamSize'] as Vector2;

      await game.ensureAdd(team);

      final playersComponent = team.children.whereType<Players>().first;
      final stats = playersComponent.children.whereType<PlayerStats>().toList();
      final base = team.children.whereType<Bases>().first;
      expect(stats.length, 3);
      expect(team.children.whereType<Bases>().length, 1);
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
