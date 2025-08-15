import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/models/player/card_pile_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';

void main() {
  group('CardPileModel', () {
    group('constructor and initialization', () {
      test('creates with default empty pile when no parameters provided', () {
        final model = CardPileModel();
        
        expect(model.allCards.length, equals(0));
        expect(model.hasNoCards, isTrue);
      });

      test('creates with specified number of cards', () {
        final testCases = [
          {'numberOfCards': 1, 'expectedLength': 1},
          {'numberOfCards': 3, 'expectedLength': 3},
          {'numberOfCards': 5, 'expectedLength': 5},
          {'numberOfCards': 0, 'expectedLength': 0},
        ];

        for (final testCase in testCases) {
          final model = CardPileModel(numberOfCards: testCase['numberOfCards'] as int);
          
          expect(model.allCards.length, equals(testCase['expectedLength']));
          expect(model.hasNoCards, equals(testCase['expectedLength'] == 0));
          
          // Check generated cards have correct properties
          for (int i = 0; i < (testCase['expectedLength'] as int); i++) {
            expect(model.allCards[i].name, equals('Card ${i + 1}'));
            expect(model.allCards[i].cost, equals(1));
            expect(model.allCards[i].isFaceUp, isFalse);
          }
        }
      });

      test('creates with provided cards list', () {
        final cards = [
          CardModel(name: 'Custom Card 1', cost: 2),
          CardModel(name: 'Custom Card 2', cost: 5),
        ];
        final model = CardPileModel(cards: cards);
        
        expect(model.allCards.length, equals(2));
        expect(model.hasNoCards, isFalse);
        expect(model.allCards, equals(cards));
      });

      test('provided cards list takes precedence over numberOfCards', () {
        final cards = [
          CardModel(name: 'Override Card', cost: 3),
        ];
        final model = CardPileModel(numberOfCards: 5, cards: cards);
        
        expect(model.allCards.length, equals(1));
        expect(model.allCards.first.name, equals('Override Card'));
        expect(model.hasNoCards, isFalse);
      });

      test('creates empty pile using named constructor', () {
        final model = CardPileModel.empty();
        
        expect(model.allCards.length, equals(0));
        expect(model.hasNoCards, isTrue);
      });

      test('creates empty pile with empty cards list', () {
        final model = CardPileModel(cards: []);
        
        expect(model.allCards.length, equals(0));
        expect(model.hasNoCards, isTrue);
      });
    });

    group('properties', () {
      test('allCards returns unmodifiable list', () {
        final model = CardPileModel(numberOfCards: 2);
        final cards = model.allCards;
        
        expect(() => cards.add(CardModel(name: 'Test', cost: 1)), 
               throwsUnsupportedError);
      });

      test('hasNoCards returns correct value for non-empty pile', () {
        final model = CardPileModel(numberOfCards: 3);
        expect(model.hasNoCards, isFalse);
      });

      test('hasNoCards returns correct value for empty pile', () {
        final model = CardPileModel.empty();
        expect(model.hasNoCards, isTrue);
      });

      test('hasNoCards returns correct value for pile with provided empty list', () {
        final model = CardPileModel(cards: []);
        expect(model.hasNoCards, isTrue);
      });

      test('hasNoCards returns correct value for pile with numberOfCards = 0', () {
        final model = CardPileModel(numberOfCards: 0);
        expect(model.hasNoCards, isTrue);
      });
    });
  });
}