import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/models/team/team_model.dart';
import 'package:card_battler/game/models/team/bases_model.dart';

void main() {
  group('TeamModel', () {
    late BasesModel testBasesModel;
    late List<String> testPlayerNames;

    setUp(() {
      testBasesModel = BasesModel(totalBases: 3, baseMaxHealth: 5);
      testPlayerNames = ['Player 1', 'Player 2', 'Player 3'];
    });

    group('constructor and initialization', () {
      test('creates with required parameters', () {
        final teamModel = TeamModel(
          bases: testBasesModel,
          playerNames: testPlayerNames,
        );

        expect(teamModel.bases, equals(testBasesModel));
        expect(teamModel.playerNames, equals(testPlayerNames));
      });

      test('stores references to provided models', () {
        final teamModel = TeamModel(
          bases: testBasesModel,
          playerNames: testPlayerNames,
        );

        // Verify that the same instances are returned
        expect(identical(teamModel.bases, testBasesModel), isTrue);
        expect(identical(teamModel.playerNames, testPlayerNames), isTrue);
      });
    });

    group('property getters', () {
      test('bases getter returns correct BasesModel', () {
        final teamModel = TeamModel(
          bases: testBasesModel,
          playerNames: testPlayerNames,
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
          playerNames: testPlayerNames,
        );

        expect(teamModel.playerNames, isA<List<String>>());
        expect(teamModel.playerNames, equals(testPlayerNames));
        expect(teamModel.playerNames.length, equals(3));
        expect(teamModel.playerNames, contains('Player 1'));
        expect(teamModel.playerNames, contains('Player 2'));
        expect(teamModel.playerNames, contains('Player 3'));
      });
    });
  });
}
