import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:card_battler/game/models/team/player_stats_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/models/team/team_model.dart';
import 'package:card_battler/game/models/team/bases_model.dart';

void main() {
  group('TeamModel', () {
    late BasesModel testBasesModel;
    late List<PlayerStatsModel> players;

    setUp(() {
      testBasesModel = BasesModel(totalBases: 3, baseMaxHealth: 5);
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

    group('property getters', () {
      test('bases getter returns correct BasesModel', () {
        final teamModel = TeamModel(
          bases: testBasesModel,
          players: players,
        );

        expect(teamModel.bases, isA<BasesModel>());
        expect(teamModel.bases, equals(testBasesModel));
        expect(teamModel.bases.allBases.length, equals(3));
        expect(teamModel.bases.currentBaseIndex, equals(2));
        expect(teamModel.bases.displayText, equals('Base 1 of 3'));
      });

      test('playerNames getter returns correct List<String>', () {
        final teamModel = TeamModel(
          bases: testBasesModel,
          players: players,
        );

        expect(teamModel.players, isA<List<PlayerStatsModel>>());
        expect(teamModel.players, equals(players));
        expect(teamModel.players.length, equals(3));
      });
    });
  });
}
