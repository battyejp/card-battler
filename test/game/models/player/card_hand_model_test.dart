import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/models/player/card_hand_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';

void main() {
  group('CardHandModel', () {
    group('constructor and initialization', () {
      test('creates with empty cards list initially', () {
        final cardHand = CardHandModel();
        
        expect(cardHand.cards, isNotNull);
        expect(cardHand.cards, isA<List<CardModel>>());
        expect(cardHand.cards, isEmpty);
      });

      test('starts with no cards in hand', () {
        final cardHand = CardHandModel();
        
        expect(cardHand.cards.length, equals(0));
      });

      test('cards list is mutable and can be modified', () {
        final cardHand = CardHandModel();
        expect(cardHand.cards, isEmpty);
        
        final testCard = CardModel(name: 'Test Card', cost: 1);
        cardHand.addCard(testCard);
        
        expect(cardHand.cards.length, equals(1));
        expect(cardHand.cards.first.name, equals('Test Card'));
      });
    });

    group('property access', () {
      late CardHandModel cardHand;
      
      setUp(() {
        cardHand = CardHandModel();
        // Add some test cards for property testing
        cardHand.addCards([
          CardModel(name: 'Test Card 1', cost: 1),
          CardModel(name: 'Test Card 2', cost: 2),
        ]);
      });

      test('cards getter returns correct list', () {
        final cards = cardHand.cards;
        
        expect(cards, isNotNull);
        expect(cards.length, equals(2));
        expect(cards, isA<List<CardModel>>());
      });

      test('cards getter returns same reference on multiple calls', () {
        final cards1 = cardHand.cards;
        final cards2 = cardHand.cards;
        
        expect(cards1, same(cards2));
      });

      test('cards list contains proper CardModel instances', () {
        final cards = cardHand.cards;
        
        for (final card in cards) {
          expect(card, isA<CardModel>());
          expect(card.name, isNotEmpty);
          expect(card.cost, isNonNegative);
        }
      });

      test('empty hand returns empty cards list', () {
        final emptyHand = CardHandModel();
        
        expect(emptyHand.cards, isEmpty);
        expect(emptyHand.cards, isA<List<CardModel>>());
      });
    });


    group('multiple instances', () {
      test('different instances have independent card lists', () {
        final cardHand1 = CardHandModel();
        final cardHand2 = CardHandModel();
        
        expect(cardHand1.cards, isNot(same(cardHand2.cards)));
        expect(cardHand1.cards.length, equals(cardHand2.cards.length));
        expect(cardHand1.cards.length, equals(0)); // Both start empty
      });

      test('modifications to one instance do not affect another', () {
        final cardHand1 = CardHandModel();
        final cardHand2 = CardHandModel();
        
        cardHand1.addCard(CardModel(name: 'Test Card', cost: 5));
        
        expect(cardHand1.cards.length, equals(1));
        expect(cardHand2.cards.length, equals(0));
        expect(cardHand2.cards, isEmpty);
      });

      test('multiple instances can be used independently', () {
        final cardHand1 = CardHandModel();
        final cardHand2 = CardHandModel();
        
        cardHand1.addCard(CardModel(name: 'Hand 1 Card', cost: 1));
        cardHand2.addCards([
          CardModel(name: 'Hand 2 Card A', cost: 2),
          CardModel(name: 'Hand 2 Card B', cost: 3),
        ]);
        
        expect(cardHand1.cards.length, equals(1));
        expect(cardHand1.cards.first.name, equals('Hand 1 Card'));
        
        expect(cardHand2.cards.length, equals(2));
        expect(cardHand2.cards.first.name, equals('Hand 2 Card A'));
        expect(cardHand2.cards.last.name, equals('Hand 2 Card B'));
      });
    });

    group('card management methods', () {
      group('addCards', () {
        test('adds multiple cards to existing hand', () {
          final cardHand = CardHandModel();
          final initialCount = cardHand.cards.length;
          final newCards = [
            CardModel(name: 'New Card 1', cost: 2),
            CardModel(name: 'New Card 2', cost: 3),
          ];
          
          cardHand.addCards(newCards);
          
          expect(cardHand.cards.length, equals(initialCount + 2));
          expect(cardHand.cards[initialCount].name, equals('New Card 1'));
          expect(cardHand.cards[initialCount + 1].name, equals('New Card 2'));
        });

        test('adds empty list without changing hand', () {
          final cardHand = CardHandModel();
          final initialCount = cardHand.cards.length;
          
          cardHand.addCards([]);
          
          expect(cardHand.cards.length, equals(initialCount));
        });

        test('preserves original cards when adding new ones', () {
          final cardHand = CardHandModel();
          // Add some initial cards first
          cardHand.addCard(CardModel(name: 'Original Card', cost: 1));
          final originalFirstCard = cardHand.cards.first.name;
          final newCards = [CardModel(name: 'Added Card', cost: 5)];
          
          cardHand.addCards(newCards);
          
          expect(cardHand.cards.first.name, equals(originalFirstCard));
          expect(cardHand.cards.last.name, equals('Added Card'));
        });
      });

      group('addCard', () {
        test('adds single card to existing hand', () {
          final cardHand = CardHandModel();
          final initialCount = cardHand.cards.length;
          final newCard = CardModel(name: 'Single New Card', cost: 4);
          
          cardHand.addCard(newCard);
          
          expect(cardHand.cards.length, equals(initialCount + 1));
          expect(cardHand.cards.last.name, equals('Single New Card'));
          expect(cardHand.cards.last.cost, equals(4));
        });

        test('preserves original cards when adding single card', () {
          final cardHand = CardHandModel();
          final originalCards = List<CardModel>.from(cardHand.cards);
          final newCard = CardModel(name: 'Added Single Card', cost: 6);
          
          cardHand.addCard(newCard);
          
          for (int i = 0; i < originalCards.length; i++) {
            expect(cardHand.cards[i].name, equals(originalCards[i].name));
          }
          expect(cardHand.cards.last.name, equals('Added Single Card'));
        });
      });

      group('clearCards', () {
        test('removes all cards from hand', () {
          final cardHand = CardHandModel();
          // Add some cards first to test clearing
          cardHand.addCards([
            CardModel(name: 'Card 1', cost: 1),
            CardModel(name: 'Card 2', cost: 2),
          ]);
          expect(cardHand.cards, isNotEmpty);
          
          cardHand.clearCards();
          
          expect(cardHand.cards, isEmpty);
        });

        test('clearCards on empty hand does nothing', () {
          final cardHand = CardHandModel();
          cardHand.clearCards();
          expect(cardHand.cards, isEmpty);
          
          cardHand.clearCards(); // Clear again
          
          expect(cardHand.cards, isEmpty);
        });

        test('can add cards after clearing', () {
          final cardHand = CardHandModel();
          cardHand.clearCards();
          final newCard = CardModel(name: 'Post-Clear Card', cost: 7);
          
          cardHand.addCard(newCard);
          
          expect(cardHand.cards.length, equals(1));
          expect(cardHand.cards.first.name, equals('Post-Clear Card'));
        });
      });

      group('replaceCards', () {
        test('replaces all cards with new ones', () {
          final cardHand = CardHandModel();
          final newCards = [
            CardModel(name: 'Replacement 1', cost: 8),
            CardModel(name: 'Replacement 2', cost: 9),
          ];
          
          cardHand.replaceCards(newCards);
          
          expect(cardHand.cards.length, equals(2));
          expect(cardHand.cards[0].name, equals('Replacement 1'));
          expect(cardHand.cards[1].name, equals('Replacement 2'));
        });

        test('replaces cards with empty list', () {
          final cardHand = CardHandModel();
          // Add some cards first to test replacing with empty list
          cardHand.addCards([
            CardModel(name: 'Card A', cost: 1),
            CardModel(name: 'Card B', cost: 2),
          ]);
          expect(cardHand.cards, isNotEmpty);
          
          cardHand.replaceCards([]);
          
          expect(cardHand.cards, isEmpty);
        });

        test('replaces empty hand with new cards', () {
          final cardHand = CardHandModel();
          cardHand.clearCards();
          final newCards = [CardModel(name: 'New After Replace', cost: 10)];
          
          cardHand.replaceCards(newCards);
          
          expect(cardHand.cards.length, equals(1));
          expect(cardHand.cards.first.name, equals('New After Replace'));
        });

        test('completely replaces previous cards', () {
          final cardHand = CardHandModel();
          final originalCardNames = cardHand.cards.map((c) => c.name).toSet();
          final newCards = [
            CardModel(name: 'Totally New 1', cost: 11),
            CardModel(name: 'Totally New 2', cost: 12),
          ];
          
          cardHand.replaceCards(newCards);
          
          for (final card in cardHand.cards) {
            expect(originalCardNames.contains(card.name), isFalse);
          }
        });
      });

      group('method combinations', () {
        test('addCards after clearCards works correctly', () {
          final cardHand = CardHandModel();
          cardHand.clearCards();
          final newCards = [CardModel(name: 'After Clear', cost: 13)];
          
          cardHand.addCards(newCards);
          
          expect(cardHand.cards.length, equals(1));
          expect(cardHand.cards.first.name, equals('After Clear'));
        });

        test('multiple addCard calls work correctly', () {
          final cardHand = CardHandModel();
          cardHand.clearCards();
          
          cardHand.addCard(CardModel(name: 'First', cost: 1));
          cardHand.addCard(CardModel(name: 'Second', cost: 2));
          cardHand.addCard(CardModel(name: 'Third', cost: 3));
          
          expect(cardHand.cards.length, equals(3));
          expect(cardHand.cards.map((c) => c.name).toList(), equals(['First', 'Second', 'Third']));
        });
      });
    });
  });
}