import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:card_battler/game/models/team/player_stats_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/models/team/team_model.dart';
import 'package:card_battler/game/models/team/bases_model.dart';
import 'package:card_battler/game/models/team/base_model.dart';

void main() {
  group('TeamModel', () {
    late BasesModel testBasesModel;
    late List<PlayerStatsModel> players;

    setUp(() {
      final bases = [
        BaseModel(name: 'Base 1', maxHealth: 5),
        BaseModel(name: 'Base 2', maxHealth: 5),
        BaseModel(name: 'Base 3', maxHealth: 5),
      ];
      testBasesModel = BasesModel(bases: bases);
      players = [
        PlayerStatsModel(name: 'Player 1', health: HealthModel(maxHealth: 100)),
        PlayerStatsModel(name: 'Player 2', health: HealthModel(maxHealth: 100)),
        PlayerStatsModel(name: 'Player 3', health: HealthModel(maxHealth: 100)),
      ];

    });

    group('constructor and initialization', () {
      test('creates with required parameters', () {
        final teamModel = TeamModel(
          bases: testBasesModel,
          players: players,
        );

        expect(teamModel.bases, equals(testBasesModel));
        expect(teamModel.players, equals(players));
      });

      test('stores references to provided models', () {
        final teamModel = TeamModel(
          bases: testBasesModel,
          players: players,
        );

        // Verify that the same instances are returned
        expect(identical(teamModel.bases, testBasesModel), isTrue);
        expect(identical(teamModel.players, players), isTrue);
      });
    });

  });
}
