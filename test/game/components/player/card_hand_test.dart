import 'package:card_battler/game_legacy/models/shared/cards_model.dart';
import 'package:card_battler/game_legacy/models/shared/card_model.dart';
import 'package:card_battler/game_legacy/components/shared/card/card.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game_legacy/components/player/card_hand.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  group('CardHand', () {
    group('basic component properties', () {
      final testCases = [
        {'size': Vector2(100, 100), 'pos': Vector2(10, 20)},
        {'size': Vector2(200, 200), 'pos': Vector2(0, 0)},
        {'size': Vector2(300, 150), 'pos': Vector2(50, 25)},
      ];
      
      for (final testCase in testCases) {
        testWithFlameGame('Hand size and position for size ${testCase['size']} pos ${testCase['pos']}', (game) async {
          final hand = CardHand(CardsModel<CardModel>())
            ..size = testCase['size'] as Vector2
            ..position = testCase['pos'] as Vector2;

          await game.ensureAdd(hand);

          expect(game.children.contains(hand), isTrue);
          expect(hand.size, testCase['size']);
          expect(hand.position, testCase['pos']);
        });
      }
    });

    group('empty hand display', () {
      testWithFlameGame('displays no cards when hand is empty', (game) async {
        final model = CardsModel<CardModel>();
        final hand = CardHand(model)..size = Vector2(300, 150);

        await game.ensureAdd(hand);

        final cards = hand.children.whereType<Card>().toList();
        expect(cards, isEmpty);
      });

      testWithFlameGame('reactive updates handle empty hand correctly', (game) async {
        final model = CardsModel<CardModel>();
        final hand = CardHand(model)..size = Vector2(300, 150);

        await game.ensureAdd(hand);

        // Adding and removing cards should trigger reactive updates
        model.addCard(CardModel(name: 'Test', type: 'Player'));
        await game.ready();
        expect(hand.children.whereType<Card>().length, equals(1));

        model.clearCards();
        await game.ready();
        expect(hand.children.whereType<Card>().length, equals(0));
      });
    });

    group('card display and layout', () {
      testWithFlameGame('displays cards with correct layout parameters', (game) async {
        final model = CardsModel<CardModel>();
        model.addCards([
          CardModel(name: 'Card 1', type: 'Player'),
          CardModel(name: 'Card 2', type: 'Player'),
          CardModel(name: 'Card 3', type: 'Player'),
        ]);
        final hand = CardHand(model)..size = Vector2(400, 200);

        await game.ensureAdd(hand);

        final cards = hand.children.whereType<Card>().toList();
        expect(cards.length, equals(3));

        // Check card dimensions (15% width, 80% height)
        final expectedCardWidth = 400 * 0.15; // 60
        final expectedCardHeight = 200 * 0.8; // 160
        
        for (final card in cards) {
          expect(card.size.x, equals(expectedCardWidth));
          expect(card.size.y, equals(expectedCardHeight));
        }
      });

      testWithFlameGame('positions cards with correct spacing', (game) async {
        final model = CardsModel<CardModel>();
        model.addCards([
          CardModel(name: 'Card 1', type: 'Player'),
          CardModel(name: 'Card 2', type: 'Player'),
        ]);
        final hand = CardHand(model)..size = Vector2(400, 200);

        await game.ensureAdd(hand);

        final cards = hand.children.whereType<Card>().toList();
        expect(cards.length, equals(2));

        final cardWidth = 400 * 0.15; // 60
        final spacing = 20;
        final totalWidth = (cardWidth * 2) + (spacing * 1); // 140
        final expectedStartX = (400 - totalWidth) / 2; // 130

        // Check first card position
        expect(cards[0].position.x, equals(expectedStartX));
        
        // Check second card position (first card x + card width + spacing)
        expect(cards[1].position.x, equals(expectedStartX + cardWidth + spacing));
      });

      testWithFlameGame('centers cards vertically', (game) async {
        final model = CardsModel<CardModel>();
        model.addCard(CardModel(name: 'Test Card', type: 'Player'));
        final hand = CardHand(model)..size = Vector2(400, 200);

        await game.ensureAdd(hand);

        final cards = hand.children.whereType<Card>().toList();
        expect(cards.length, equals(1));

        final cardHeight = 200 * 0.8; // 160
        final expectedY = (200 - cardHeight) / 2; // 20
        
        expect(cards[0].position.y, equals(expectedY));
      });

      testWithFlameGame('handles single card layout', (game) async {
        final model = CardsModel<CardModel>();
        model.addCard(CardModel(name: 'Single Card', type: 'Player'));
        final hand = CardHand(model)..size = Vector2(300, 150);

        await game.ensureAdd(hand);

        final cards = hand.children.whereType<Card>().toList();
        expect(cards.length, equals(1));

        final cardWidth = 300 * 0.15; // 45
        final expectedCenterX = (300 - cardWidth) / 2; // 127.5
        
        expect(cards[0].position.x, equals(expectedCenterX));
      });

      testWithFlameGame('handles multiple cards with different hand sizes', (game) async {
        final testCases = [
          {'handSize': Vector2(600, 300), 'cardCount': 5},
          {'handSize': Vector2(800, 400), 'cardCount': 3},
          {'handSize': Vector2(400, 200), 'cardCount': 7},
        ];

        for (final testCase in testCases) {
          final model = CardsModel<CardModel>();
          final cardCount = testCase['cardCount'] as int;
          
          for (int i = 0; i < cardCount; i++) {
            model.addCard(CardModel(name: 'Card ${i + 1}', type: 'Player'));
          }
          
          final handSize = testCase['handSize'] as Vector2;
          final hand = CardHand(model)..size = handSize;

          await game.ensureAdd(hand);

          final cards = hand.children.whereType<Card>().toList();
          expect(cards.length, equals(cardCount));

          // Verify layout calculations
          final cardWidth = handSize.x * 0.15;
          final spacing = 20;
          final totalWidth = (cardWidth * cardCount) + (spacing * (cardCount - 1));
          final startX = (handSize.x - totalWidth) / 2;

          for (int i = 0; i < cardCount; i++) {
            final expectedX = startX + (i * (cardWidth + spacing));
            expect(cards[i].position.x, equals(expectedX));
          }

          game.remove(hand);
        }
      });
    });

    group('reactive updates', () {
      testWithFlameGame('automatically updates card positions after model changes', (game) async {
        final model = CardsModel<CardModel>();
        model.addCard(CardModel(name: 'Initial Card', type: 'Player'));
        final hand = CardHand(model)..size = Vector2(400, 200);

        await game.ensureAdd(hand);

        expect(hand.children.whereType<Card>().length, equals(1));

        // Add more cards to model - should trigger automatic update
        model.addCards([
          CardModel(name: 'Added Card 1', type: 'Player'),
          CardModel(name: 'Added Card 2', type: 'Player'),
        ]);

        await game.ready();

        final cards = hand.children.whereType<Card>().toList();
        expect(cards.length, equals(3));
      });

      testWithFlameGame('automatically clears old cards before adding new ones', (game) async {
        final model = CardsModel<CardModel>();
        model.addCards([
          CardModel(name: 'Card 1', type: 'Player'),
          CardModel(name: 'Card 2', type: 'Player'),
        ]);
        final hand = CardHand(model)..size = Vector2(400, 200);

        await game.ensureAdd(hand);
        expect(hand.children.whereType<Card>().length, equals(2));

        // Clear model and add different cards - should trigger automatic update
        model.clearCards();
        await game.ready(); // Wait for clear to process
        
        model.addCard(CardModel(name: 'New Card', type: 'Player'));
        await game.ready(); // Wait for add to process

        final cards = hand.children.whereType<Card>().toList();
        expect(cards.length, equals(1));
        expect(cards[0].cardModel.name, equals('New Card'));
      });

      testWithFlameGame('handles multiple model changes reactively', (game) async {
        final model = CardsModel<CardModel>();
        final hand = CardHand(model)..size = Vector2(400, 200);

        await game.ensureAdd(hand);

        // Start empty
        expect(hand.children.whereType<Card>().length, equals(0));

        // Add cards - should trigger automatic update
        model.addCard(CardModel(name: 'Card 1', type: 'Player'));
        await game.ready();
        expect(hand.children.whereType<Card>().length, equals(1));

        // Add more cards - should trigger automatic update
        model.addCard(CardModel(name: 'Card 2', type: 'Player'));
        await game.ready();
        expect(hand.children.whereType<Card>().length, equals(2));

        // Clear - should trigger automatic update
        model.clearCards();
        await game.ready();
        expect(hand.children.whereType<Card>().length, equals(0));
      });

      testWithFlameGame('cleans up stream subscription on component removal', (game) async {
        final model = CardsModel<CardModel>();
        final hand = CardHand(model)..size = Vector2(400, 200);

        await game.ensureAdd(hand);
        
        // Verify component is mounted and working
        expect(hand.isMounted, true);
        
        // Remove the component
        game.remove(hand);
        await game.ready();
        
        // Verify component is removed
        expect(hand.isMounted, false);
        
        // Adding cards to model after component removal should not cause errors
        expect(() => model.addCard(CardModel(name: 'Test', type: 'Player')), returnsNormally);
      });
    });

    group('integration with CardsModel<CardModel>', () {
      testWithFlameGame('displays cards from model correctly', (game) async {
        final model = CardsModel<CardModel>();
        final testCards = [
          CardModel(name: 'Test Card A', type: 'Player'),
          CardModel(name: 'Test Card B', type: 'Player'),
          CardModel(name: 'Test Card C', type: 'Player'),
        ];
        model.addCards(testCards);
        
        final hand = CardHand(model)..size = Vector2(500, 250);

        await game.ensureAdd(hand);

        final displayedCards = hand.children.whereType<Card>().toList();
        expect(displayedCards.length, equals(3));
        
        // Verify the cards match the model
        for (int i = 0; i < testCards.length; i++) {
          expect(displayedCards[i].cardModel.name, equals(testCards[i].name));
        }
      });

      testWithFlameGame('handles model changes correctly', (game) async {
        final model = CardsModel<CardModel>();
        final hand = CardHand(model)..size = Vector2(400, 200);

        await game.ensureAdd(hand);

        // Start empty
        expect(hand.children.whereType<Card>().length, equals(0));

        // Add cards to model - should trigger automatic update
        model.addCards([
          CardModel(name: 'Dynamic Card 1', type: 'Player'),
          CardModel(name: 'Dynamic Card 2', type: 'Player'),
        ]);
        await game.ready();

        expect(hand.children.whereType<Card>().length, equals(2));
      });
    });
  });
}
