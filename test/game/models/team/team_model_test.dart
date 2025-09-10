import 'package:card_battler/game_legacy/models/shared/health_model.dart';
import 'package:card_battler/game_legacy/models/team/player_stats_model.dart';
import 'package:card_battler/game_legacy/models/team/players_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game_legacy/models/team/team_model.dart';
import 'package:card_battler/game_legacy/models/team/bases_model.dart';
import 'package:card_battler/game_legacy/models/team/base_model.dart';

void main() {
  group('TeamModel', () {
    late BasesModel testBasesModel;
    late PlayersModel playersModel;

    setUp(() {
      final bases = [
        BaseModel(name: 'Base 1', maxHealth: 5),
        BaseModel(name: 'Base 2', maxHealth: 5),
        BaseModel(name: 'Base 3', maxHealth: 5),
      ];
      testBasesModel = BasesModel(bases: bases);
      final players = [
        PlayerStatsModel(name: 'Player 1', health: HealthModel(maxHealth: 100), isActive: false),
        PlayerStatsModel(name: 'Player 2', health: HealthModel(maxHealth: 100), isActive: false),
        PlayerStatsModel(name: 'Player 3', health: HealthModel(maxHealth: 100), isActive: false),
      ];
      playersModel = PlayersModel(players: players);

    });

    group('constructor and initialization', () {
      test('creates with required parameters', () {
        final teamModel = TeamModel(
          bases: testBasesModel,
          playersModel: playersModel,
        );

        expect(teamModel.bases, equals(testBasesModel));
        expect(teamModel.playersModel, equals(playersModel));
      });

      test('stores references to provided models', () {
        final teamModel = TeamModel(
          bases: testBasesModel,
          playersModel: playersModel,
        );

        // Verify that the same instances are returned
        expect(identical(teamModel.bases, testBasesModel), isTrue);
        expect(identical(teamModel.playersModel, playersModel), isTrue);
      });
    });

  });
}
