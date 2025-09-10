import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game_legacy/models/team/bases_model.dart';
import 'package:card_battler/game_legacy/models/team/base_model.dart';

void main() {
  group('BasesModel', () {
    group('constructor and initialization', () {
      test('creates with required bases parameter', () {
        final bases = [
          BaseModel(name: 'Base 1', maxHealth: 5),
          BaseModel(name: 'Base 2', maxHealth: 5),
          BaseModel(name: 'Base 3', maxHealth: 5),
        ];
        final model = BasesModel(bases: bases);
        
        expect(model.allBases.length, equals(3));
        expect(model.currentBaseIndex, equals(2)); // Last index (0-based)
      });

      test('creates bases with custom health values', () {
        final bases = [
          BaseModel(name: 'Base 1', maxHealth: 100),
          BaseModel(name: 'Base 2', maxHealth: 100),
        ];
        final model = BasesModel(bases: bases);
        
        for (final base in model.allBases) {
          expect(base.healthDisplay, equals('100/100'));
        }
      });

      test('creates bases with different health values', () {
        final bases = [
          BaseModel(name: 'Base 1', maxHealth: 50),
          BaseModel(name: 'Base 2', maxHealth: 75),
          BaseModel(name: 'Base 3', maxHealth: 100),
        ];
        final model = BasesModel(bases: bases);
        
        expect(model.allBases[0].healthDisplay, equals('50/50'));
        expect(model.allBases[1].healthDisplay, equals('75/75'));
        expect(model.allBases[2].healthDisplay, equals('100/100'));
      });

      test('assigns correct names to bases', () {
        final bases = [
          BaseModel(name: 'Base 1', maxHealth: 10),
          BaseModel(name: 'Base 2', maxHealth: 10),
          BaseModel(name: 'Base 3', maxHealth: 10),
          BaseModel(name: 'Base 4', maxHealth: 10),
        ];
        final model = BasesModel(bases: bases);
        
        expect(model.allBases[0].name, equals('Base 1'));
        expect(model.allBases[1].name, equals('Base 2'));
        expect(model.allBases[2].name, equals('Base 3'));
        expect(model.allBases[3].name, equals('Base 4'));
      });
    });

    group('current base index', () {
      test('starts at last base index', () {
        final testCases = [
          {'totalBases': 1, 'expectedIndex': 0},
          {'totalBases': 3, 'expectedIndex': 2},
          {'totalBases': 5, 'expectedIndex': 4},
        ];

        for (final testCase in testCases) {
          final totalBases = testCase['totalBases'] as int;
          final bases = List.generate(totalBases, (index) => BaseModel(name: 'Base ${index + 1}', maxHealth: 5));
          final model = BasesModel(bases: bases);
          expect(model.currentBaseIndex, equals(testCase['expectedIndex']));
        }
      });
    });

    group('display text', () {
      test('shows correct base number and total for initial state', () {
        final testCases = [
          {'totalBases': 1, 'expected': 'Base 1 of 1'},
          {'totalBases': 2, 'expected': 'Base 1 of 2'},
          {'totalBases': 5, 'expected': 'Base 1 of 5'},
        ];

        for (final testCase in testCases) {
          final totalBases = testCase['totalBases'] as int;
          final bases = List.generate(totalBases, (index) => BaseModel(name: 'Base ${index + 1}', maxHealth: 5));
          final model = BasesModel(bases: bases);
          expect(model.displayText, equals(testCase['expected']));
        }
      });

      test('calculates base number correctly from current index', () {
        // Since currentBaseIndex starts at totalBases - 1,
        // base number should always be 1 initially (bases.length - currentBaseIndex)
        final bases1 = [
          BaseModel(name: 'Base 1', maxHealth: 5),
          BaseModel(name: 'Base 2', maxHealth: 5),
          BaseModel(name: 'Base 3', maxHealth: 5),
        ];
        final model1 = BasesModel(bases: bases1); // currentBaseIndex = 2
        expect(model1.displayText, equals('Base 1 of 3')); // 3 - 2 = 1

        final bases2 = List.generate(10, (index) => BaseModel(name: 'Base ${index + 1}', maxHealth: 5));
        final model2 = BasesModel(bases: bases2); // currentBaseIndex = 9  
        expect(model2.displayText, equals('Base 1 of 10')); // 10 - 9 = 1
      });
    });

    group('all bases access', () {
      test('returns unmodifiable list of all bases', () {
        final bases = [
          BaseModel(name: 'Base 1', maxHealth: 25),
          BaseModel(name: 'Base 2', maxHealth: 25),
          BaseModel(name: 'Base 3', maxHealth: 25),
        ];
        final model = BasesModel(bases: bases);
        final returnedBases = model.allBases;
        
        expect(returnedBases.length, equals(3));
        expect(returnedBases[0].name, equals('Base 1'));
        expect(returnedBases[1].name, equals('Base 2'));
        expect(returnedBases[2].name, equals('Base 3'));
        
        for (final base in returnedBases) {
          expect(base.healthDisplay, equals('25/25'));
        }
      });

      test('returned list is unmodifiable', () {
        final bases = [
          BaseModel(name: 'Base 1', maxHealth: 5),
          BaseModel(name: 'Base 2', maxHealth: 5),
        ];
        final model = BasesModel(bases: bases);
        final returnedBases = model.allBases;
        
        expect(() => returnedBases.add(BaseModel(name: 'Extra', maxHealth: 10)), 
               throwsUnsupportedError);
        expect(() => returnedBases.removeAt(0), throwsUnsupportedError);
        expect(() => returnedBases.clear(), throwsUnsupportedError);
      });

      test('multiple calls return same data', () {
        final bases = [
          BaseModel(name: 'Base 1', maxHealth: 50),
          BaseModel(name: 'Base 2', maxHealth: 50),
          BaseModel(name: 'Base 3', maxHealth: 50),
          BaseModel(name: 'Base 4', maxHealth: 50),
        ];
        final model = BasesModel(bases: bases);
        final bases1 = model.allBases;
        final bases2 = model.allBases;
        
        expect(bases1.length, equals(bases2.length));
        for (int i = 0; i < bases1.length; i++) {
          expect(bases1[i].name, equals(bases2[i].name));
          expect(bases1[i].healthDisplay, equals(bases2[i].healthDisplay));
        }
      });
    });
  });
}