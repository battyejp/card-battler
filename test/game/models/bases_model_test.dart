import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/models/bases_model.dart';
import 'package:card_battler/game/models/base_model.dart';

void main() {
  group('BasesModel', () {
    group('constructor and initialization', () {
      test('creates with required totalBases parameter', () {
        final model = BasesModel(totalBases: 3);
        
        expect(model.allBases.length, equals(3));
        expect(model.currentBaseIndex, equals(2)); // Last index (0-based)
      });

      test('creates bases with default max health', () {
        final model = BasesModel(totalBases: 2);
        
        for (final base in model.allBases) {
          expect(base.healthDisplay, equals('5/5')); // Default baseMaxHealth is 5
        }
      });

      test('creates bases with custom max health', () {
        final model = BasesModel(totalBases: 3, baseMaxHealth: 100);
        
        for (final base in model.allBases) {
          expect(base.healthDisplay, equals('100/100'));
        }
      });

      test('assigns correct names to bases', () {
        final model = BasesModel(totalBases: 4, baseMaxHealth: 10);
        
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
          final model = BasesModel(totalBases: testCase['totalBases'] as int);
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
          final model = BasesModel(totalBases: testCase['totalBases'] as int);
          expect(model.displayText, equals(testCase['expected']));
        }
      });

      test('calculates base number correctly from current index', () {
        // Since currentBaseIndex starts at totalBases - 1,
        // base number should always be 1 initially (bases.length - currentBaseIndex)
        final model1 = BasesModel(totalBases: 3); // currentBaseIndex = 2
        expect(model1.displayText, equals('Base 1 of 3')); // 3 - 2 = 1

        final model2 = BasesModel(totalBases: 10); // currentBaseIndex = 9  
        expect(model2.displayText, equals('Base 1 of 10')); // 10 - 9 = 1
      });
    });

    group('all bases access', () {
      test('returns unmodifiable list of all bases', () {
        final model = BasesModel(totalBases: 3, baseMaxHealth: 25);
        final bases = model.allBases;
        
        expect(bases.length, equals(3));
        expect(bases[0].name, equals('Base 1'));
        expect(bases[1].name, equals('Base 2'));
        expect(bases[2].name, equals('Base 3'));
        
        for (final base in bases) {
          expect(base.healthDisplay, equals('25/25'));
        }
      });

      test('returned list is unmodifiable', () {
        final model = BasesModel(totalBases: 2);
        final bases = model.allBases;
        
        expect(() => bases.add(BaseModel(name: 'Extra', maxHealth: 10)), 
               throwsUnsupportedError);
        expect(() => bases.removeAt(0), throwsUnsupportedError);
        expect(() => bases.clear(), throwsUnsupportedError);
      });

      test('multiple calls return same data', () {
        final model = BasesModel(totalBases: 4, baseMaxHealth: 50);
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