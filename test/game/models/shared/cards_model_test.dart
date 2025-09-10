import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game_legacy/models/shared/cards_model.dart';
import 'package:card_battler/game_legacy/models/shared/card_model.dart';

List<CardModel> _generateCards(int count) {
  return List.generate(count, (index) => CardModel(
    name: 'Card ${index + 1}',
    type: 'test',
    isFaceUp: false,
  ));
}

void main() {
  group('CardsModel<CardModel>', () {
    group('constructor and initialization', () {
      test('creates with default empty pile when no parameters provided', () {
        final model = CardsModel<CardModel>();
        
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
          final cardCount = testCase['numberOfCards'] as int;
          final model = CardsModel<CardModel>(cards: _generateCards(cardCount));
          
          expect(model.allCards.length, equals(testCase['expectedLength']));
          expect(model.hasNoCards, equals(testCase['expectedLength'] == 0));
          
          // Check generated cards have correct properties
          for (int i = 0; i < (testCase['expectedLength'] as int); i++) {
            expect(model.allCards[i].name, equals('Card ${i + 1}'));
            expect(model.allCards[i].isFaceUp, isFalse);
          }
        }
      });

      test('creates with provided cards list', () {
        final cards = [
          CardModel(name: 'Custom Card 1', type: 'Player'),
          CardModel(name: 'Custom Card 2', type: 'Player'),
        ];
        final model = CardsModel<CardModel>(cards: cards);
        
        expect(model.allCards.length, equals(2));
        expect(model.hasNoCards, isFalse);
        expect(model.allCards, equals(cards));
      });

      test('creates with provided cards list', () {
        final cards = [
          CardModel(name: 'Override Card', type: 'Player'),
        ];
        final model = CardsModel<CardModel>(cards: cards);
        
        expect(model.allCards.length, equals(1));
        expect(model.allCards.first.name, equals('Override Card'));
        expect(model.hasNoCards, isFalse);
      });

      test('creates empty pile using named constructor', () {
        final model = CardsModel<CardModel>.empty();
        
        expect(model.allCards.length, equals(0));
        expect(model.hasNoCards, isTrue);
      });

      test('creates empty pile with empty cards list', () {
        final model = CardsModel<CardModel>(cards: []);
        
        expect(model.allCards.length, equals(0));
        expect(model.hasNoCards, isTrue);
      });
    });

    group('properties', () {
      test('allCards returns unmodifiable list', () {
        final model = CardsModel<CardModel>(cards: _generateCards(2));
        final cards = model.allCards;
        
        expect(() => cards.add(CardModel(name: 'Test', type: 'Player')), 
               throwsUnsupportedError);
      });

      test('hasNoCards returns correct value for non-empty pile', () {
        final model = CardsModel<CardModel>(cards: _generateCards(3));
        expect(model.hasNoCards, isFalse);
      });

      test('hasNoCards returns correct value for empty pile', () {
        final model = CardsModel<CardModel>.empty();
        expect(model.hasNoCards, isTrue);
      });

      test('hasNoCards returns correct value for pile with provided empty list', () {
        final model = CardsModel<CardModel>(cards: []);
        expect(model.hasNoCards, isTrue);
      });

      test('hasNoCards returns correct value for pile with empty cards list', () {
        final model = CardsModel<CardModel>(cards: _generateCards(0));
        expect(model.hasNoCards, isTrue);
      });
    });

    group('card drawing methods', () {
      group('drawCards', () {
        test('draws correct number of cards from pile', () {
          final model = CardsModel<CardModel>(cards: _generateCards(10));
          final originalCount = model.allCards.length;
          
          final drawnCards = model.drawCards(3);
          
          expect(drawnCards.length, equals(3));
          expect(model.allCards.length, equals(originalCount - 3));
        });

        test('draws cards from the top of the pile', () {
          final cards = [
            CardModel(name: 'Top Card', type: 'Player'),
            CardModel(name: 'Middle Card', type: 'Player'),
            CardModel(name: 'Bottom Card', type: 'Player'),
          ];
          final model = CardsModel<CardModel>(cards: cards);
          
          final drawnCards = model.drawCards(2);
          
          expect(drawnCards[0].name, equals('Top Card'));
          expect(drawnCards[1].name, equals('Middle Card'));
          expect(model.allCards.first.name, equals('Bottom Card'));
        });

        test('sets drawn cards to face up', () {
          final cards = [
            CardModel(name: 'Card 1', type: 'test', isFaceUp: false),
            CardModel(name: 'Card 2', type: 'test', isFaceUp: false),
            CardModel(name: 'Card 3', type: 'test', isFaceUp: false),
          ];
          final model = CardsModel<CardModel>(cards: cards);
          
          final drawnCards = model.drawCards(2);
          
          expect(drawnCards[0].isFaceUp, isTrue);
          expect(drawnCards[1].isFaceUp, isTrue);
          expect(model.allCards.first.isFaceUp, isFalse); // Remaining card should stay face down
        });

        test('returns empty list when drawing zero cards', () {
          final model = CardsModel<CardModel>(cards: _generateCards(5));
          
          final drawnCards = model.drawCards(0);
          
          expect(drawnCards, isEmpty);
          expect(model.allCards.length, equals(5));
        });

        test('returns empty list when drawing negative number of cards', () {
          final model = CardsModel<CardModel>(cards: _generateCards(5));
          
          final drawnCards = model.drawCards(-1);
          
          expect(drawnCards, isEmpty);
          expect(model.allCards.length, equals(5));
        });

        test('draws all available cards when requesting more than available', () {
          final model = CardsModel<CardModel>(cards: _generateCards(3));
          
          final drawnCards = model.drawCards(5);
          
          expect(drawnCards.length, equals(3));
          expect(model.allCards, isEmpty);
          expect(model.hasNoCards, isTrue);
        });

        test('returns empty list when drawing from empty pile', () {
          final model = CardsModel<CardModel>.empty();
          
          final drawnCards = model.drawCards(3);
          
          expect(drawnCards, isEmpty);
        });

        test('multiple draws work correctly', () {
          final model = CardsModel<CardModel>(cards: _generateCards(10));
          
          final firstDraw = model.drawCards(3);
          final secondDraw = model.drawCards(2);
          
          expect(firstDraw.length, equals(3));
          expect(secondDraw.length, equals(2));
          expect(model.allCards.length, equals(5));
        });
      });

      group('drawCard', () {
        test('draws single card from pile', () {
          final model = CardsModel<CardModel>(cards: _generateCards(5));
          final originalCount = model.allCards.length;
          
          final drawnCard = model.drawCard();
          
          expect(drawnCard, isNotNull);
          expect(model.allCards.length, equals(originalCount - 1));
        });

        test('draws card from the top of the pile', () {
          final cards = [
            CardModel(name: 'Top Card', type: 'Player'),
            CardModel(name: 'Bottom Card', type: 'Player'),
          ];
          final model = CardsModel<CardModel>(cards: cards);
          
          final drawnCard = model.drawCard();
          
          expect(drawnCard!.name, equals('Top Card'));
          expect(model.allCards.first.name, equals('Bottom Card'));
        });

        test('sets drawn card to face up', () {
          final cards = [
            CardModel(name: 'Test Card', type: 'test', isFaceUp: false),
            CardModel(name: 'Other Card', type: 'test', isFaceUp: false),
          ];
          final model = CardsModel<CardModel>(cards: cards);
          
          final drawnCard = model.drawCard();
          
          expect(drawnCard!.isFaceUp, isTrue);
          expect(model.allCards.first.isFaceUp, isFalse); // Remaining card should stay face down
        });

        test('returns null when drawing from empty pile', () {
          final model = CardsModel<CardModel>.empty();
          
          final drawnCard = model.drawCard();
          
          expect(drawnCard, isNull);
        });

        test('multiple single draws work correctly', () {
          final model = CardsModel<CardModel>(cards: _generateCards(3));
          
          final firstCard = model.drawCard();
          final secondCard = model.drawCard();
          final thirdCard = model.drawCard();
          final fourthCard = model.drawCard();
          
          expect(firstCard, isNotNull);
          expect(secondCard, isNotNull);
          expect(thirdCard, isNotNull);
          expect(fourthCard, isNull);
          expect(model.hasNoCards, isTrue);
        });
      });
    });

    group('shuffle method', () {
      test('shuffle changes card order', () {
        final cards = [
          CardModel(name: 'Card 1', type: 'test'),
          CardModel(name: 'Card 2', type: 'test'),
          CardModel(name: 'Card 3', type: 'test'),
          CardModel(name: 'Card 4', type: 'test'),
          CardModel(name: 'Card 5', type: 'test'),
        ];
        final model = CardsModel<CardModel>(cards: List.from(cards));
        final originalOrder = model.allCards.map((c) => c.name).toList();
        
        model.shuffle();
        
        expect(model.allCards.length, equals(5));
        final shuffledOrder = model.allCards.map((c) => c.name).toList();
        expect(shuffledOrder, isNot(equals(originalOrder)));
      });

      test('shuffle preserves all cards', () {
        final cards = [
          CardModel(name: 'Card A', type: 'test'),
          CardModel(name: 'Card B', type: 'test'),
          CardModel(name: 'Card C', type: 'test'),
        ];
        final model = CardsModel<CardModel>(cards: List.from(cards));
        final originalNames = model.allCards.map((c) => c.name).toSet();
        
        model.shuffle();
        
        final shuffledNames = model.allCards.map((c) => c.name).toSet();
        expect(shuffledNames, equals(originalNames));
        expect(model.allCards.length, equals(3));
      });

      test('shuffle works with single card', () {
        final model = CardsModel<CardModel>(cards: [CardModel(name: 'Single', type: 'test')]);
        
        model.shuffle();
        
        expect(model.allCards.length, equals(1));
        expect(model.allCards.first.name, equals('Single'));
      });

      test('shuffle works with empty pile', () {
        final model = CardsModel<CardModel>.empty();
        
        expect(() => model.shuffle(), returnsNormally);
        expect(model.allCards, isEmpty);
      });
    });
  });
}
