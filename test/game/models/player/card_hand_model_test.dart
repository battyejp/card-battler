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
        
        final testCard = CardModel(name: 'Test Card', type: 'Player');
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
          CardModel(name: 'Test Card 1', type: 'Player'),
          CardModel(name: 'Test Card 2', type: 'Player'),
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
        
        cardHand1.addCard(CardModel(name: 'Test Card', type: 'Player'));
        
        expect(cardHand1.cards.length, equals(1));
        expect(cardHand2.cards.length, equals(0));
        expect(cardHand2.cards, isEmpty);
      });

      test('multiple instances can be used independently', () {
        final cardHand1 = CardHandModel();
        final cardHand2 = CardHandModel();
        
        cardHand1.addCard(CardModel(name: 'Hand 1 Card', type: 'Player'));
        cardHand2.addCards([
          CardModel(name: 'Hand 2 Card A', type: 'Player'),
          CardModel(name: 'Hand 2 Card B', type: 'Player'),
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
            CardModel(name: 'New Card 1', type: 'Player'),
            CardModel(name: 'New Card 2', type: 'Player'),
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
          cardHand.addCard(CardModel(name: 'Original Card', type: 'Player'));
          final originalFirstCard = cardHand.cards.first.name;
          final newCards = [CardModel(name: 'Added Card', type: 'Player')];
          
          cardHand.addCards(newCards);
          
          expect(cardHand.cards.first.name, equals(originalFirstCard));
          expect(cardHand.cards.last.name, equals('Added Card'));
        });
      });

      group('addCard', () {
        test('adds single card to existing hand', () {
          final cardHand = CardHandModel();
          final initialCount = cardHand.cards.length;
          final newCard = CardModel(name: 'Single New Card', type: 'Player');
          
          cardHand.addCard(newCard);
          
          expect(cardHand.cards.length, equals(initialCount + 1));
          expect(cardHand.cards.last.name, equals('Single New Card'));
        });

        test('preserves original cards when adding single card', () {
          final cardHand = CardHandModel();
          final originalCards = List<CardModel>.from(cardHand.cards);
          final newCard = CardModel(name: 'Added Single Card', type: 'Player');
          
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
            CardModel(name: 'Card 1', type: 'Player'),
            CardModel(name: 'Card 2', type: 'Player'),
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
          final newCard = CardModel(name: 'Post-Clear Card', type: 'Player');
          
          cardHand.addCard(newCard);
          
          expect(cardHand.cards.length, equals(1));
          expect(cardHand.cards.first.name, equals('Post-Clear Card'));
        });
      });

      group('method combinations', () {
        test('addCards after clearCards works correctly', () {
          final cardHand = CardHandModel();
          cardHand.clearCards();
          final newCards = [CardModel(name: 'After Clear', type: 'Player')];
          
          cardHand.addCards(newCards);
          
          expect(cardHand.cards.length, equals(1));
          expect(cardHand.cards.first.name, equals('After Clear'));
        });

        test('multiple addCard calls work correctly', () {
          final cardHand = CardHandModel();
          cardHand.clearCards();
          
          cardHand.addCard(CardModel(name: 'First', type: 'Player'));
          cardHand.addCard(CardModel(name: 'Second', type: 'Player'));
          cardHand.addCard(CardModel(name: 'Third', type: 'Player'));
          
          expect(cardHand.cards.length, equals(3));
          expect(cardHand.cards.map((c) => c.name).toList(), equals(['First', 'Second', 'Third']));
        });
      });

      group('removeCard', () {
        test('removes specific card from hand', () {
          final cardHand = CardHandModel();
          final card1 = CardModel(name: 'Card 1', type: 'Player');
          final card2 = CardModel(name: 'Card 2', type: 'Player');
          final card3 = CardModel(name: 'Card 3', type: 'Player');
          
          cardHand.addCards([card1, card2, card3]);
          expect(cardHand.cards.length, equals(3));
          
          cardHand.removeCard(card2);
          
          expect(cardHand.cards.length, equals(2));
          expect(cardHand.cards.contains(card2), isFalse);
          expect(cardHand.cards.contains(card1), isTrue);
          expect(cardHand.cards.contains(card3), isTrue);
        });

        test('removing non-existent card does not affect hand', () {
          final cardHand = CardHandModel();
          final card1 = CardModel(name: 'Card 1', type: 'Player');
          final card2 = CardModel(name: 'Card 2', type: 'Player');
          final nonExistentCard = CardModel(name: 'Not in hand', type: 'Player');
          
          cardHand.addCards([card1, card2]);
          final initialCount = cardHand.cards.length;
          
          cardHand.removeCard(nonExistentCard);
          
          expect(cardHand.cards.length, equals(initialCount));
          expect(cardHand.cards.contains(card1), isTrue);
          expect(cardHand.cards.contains(card2), isTrue);
        });

        test('removing card from empty hand does nothing', () {
          final cardHand = CardHandModel();
          final card = CardModel(name: 'Test Card', type: 'Player');
          
          expect(cardHand.cards.isEmpty, isTrue);
          
          cardHand.removeCard(card);
          
          expect(cardHand.cards.isEmpty, isTrue);
        });

        test('removing first card works correctly', () {
          final cardHand = CardHandModel();
          final card1 = CardModel(name: 'First', type: 'Player');
          final card2 = CardModel(name: 'Second', type: 'Player');
          
          cardHand.addCards([card1, card2]);
          
          cardHand.removeCard(card1);
          
          expect(cardHand.cards.length, equals(1));
          expect(cardHand.cards.first, equals(card2));
        });

        test('removing last card works correctly', () {
          final cardHand = CardHandModel();
          final card1 = CardModel(name: 'First', type: 'Player');
          final card2 = CardModel(name: 'Last', type: 'Player');
          
          cardHand.addCards([card1, card2]);
          
          cardHand.removeCard(card2);
          
          expect(cardHand.cards.length, equals(1));
          expect(cardHand.cards.first, equals(card1));
        });

        test('removing only card empties hand', () {
          final cardHand = CardHandModel();
          final card = CardModel(name: 'Only Card', type: 'Player');
          
          cardHand.addCard(card);
          expect(cardHand.cards.length, equals(1));
          
          cardHand.removeCard(card);
          
          expect(cardHand.cards.isEmpty, isTrue);
        });
      });
    });
  });
}
