import 'package:card_battler/game/models/shared/card_pile_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/shared/card/card_deck.dart';
import 'package:card_battler/game/components/shared/card/card.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

List<CardModel> _generateCards(int count) {
  return List.generate(count, (index) => CardModel(
    name: 'Card $index',
    type: 'test',
  ));
}

void main() {
  group('CardDeck', () {
    group('inheritance from CardPile', () {
      testWithFlameGame('inherits all CardPile functionality with cards', (game) async {
        final deck = CardDeck(CardPileModel(cards: _generateCards(5)))
          ..size = Vector2(100, 150);

        await game.ensureAdd(deck);

        // Should have same card display as CardPile
        final cards = deck.children.whereType<Card>().toList();
        expect(cards.length, 1);
        
        // Should have card count label
        final textComponents = deck.children.whereType<TextComponent>().toList();
        expect(textComponents.length, 1);
        final countLabel = textComponents.first;
        expect(countLabel.text, equals('5'));
      });

      testWithFlameGame('shows "Empty" text when deck is empty', (game) async {
        final emptyDeck = CardDeck(CardPileModel.empty())
          ..size = Vector2(100, 150);

        await game.ensureAdd(emptyDeck);

        final textComponents = emptyDeck.children.whereType<TextComponent>().toList();
        expect(textComponents.length, 1);
        
        final emptyText = textComponents.first;
        expect(emptyText.text, equals('Empty'));
      });
    });

    group('tap event handling', () {
      testWithFlameGame('calls onTap callback when tapped', (game) async {
        bool tapped = false;
        final deck = CardDeck(
          CardPileModel(cards: _generateCards(3)),
          onTap: () => tapped = true,
        )..size = Vector2(100, 150);

        await game.ensureAdd(deck);

        // Simulate deck tap by calling the callback directly
        deck.onTap?.call();
        
        expect(tapped, isTrue);
      });

      testWithFlameGame('does not throw when no onTap callback provided', (game) async {
        final deck = CardDeck(CardPileModel(cards: _generateCards(3)))
          ..size = Vector2(100, 150);

        await game.ensureAdd(deck);

        expect(() => deck.onTap?.call(), returnsNormally);
      });

      testWithFlameGame('onTap callback can be called multiple times', (game) async {
        int tapCount = 0;
        final deck = CardDeck(
          CardPileModel(cards: _generateCards(3)),
          onTap: () => tapCount++,
        )..size = Vector2(100, 150);

        await game.ensureAdd(deck);

        deck.onTap?.call();
        deck.onTap?.call();
        deck.onTap?.call();
        
        expect(tapCount, equals(3));
      });

      testWithFlameGame('onTap callback receives no parameters', (game) async {
        bool callbackInvoked = false;
        void testCallback() {
          callbackInvoked = true;
        }

        final deck = CardDeck(
          CardPileModel(cards: _generateCards(3)),
          onTap: testCallback,
        )..size = Vector2(100, 150);

        await game.ensureAdd(deck);

        deck.onTap?.call();
        
        expect(callbackInvoked, isTrue);
      });
    });

    group('constructor', () {
      test('accepts CardPileModel and optional onTap callback', () {
        final model = CardPileModel(cards: _generateCards(5));
        void callback() {}

        final deckWithCallback = CardDeck(model, onTap: callback);
        final deckWithoutCallback = CardDeck(model);

        expect(deckWithCallback.model, equals(model));
        expect(deckWithCallback.onTap, equals(callback));
        expect(deckWithoutCallback.model, equals(model));
        expect(deckWithoutCallback.onTap, isNull);
      });

      test('works with empty CardPileModel', () {
        final emptyModel = CardPileModel.empty();
        
        expect(() => CardDeck(emptyModel), returnsNormally);
        
        final deck = CardDeck(emptyModel);
        expect(deck.model, equals(emptyModel));
      });
    });

    group('different deck sizes and tap handling', () {
      final testCases = [
        {'size': Vector2(100, 150), 'cards': 5},
        {'size': Vector2(200, 300), 'cards': 10},
        {'size': Vector2(80, 120), 'cards': 1},
      ];

      for (final testCase in testCases) {
        testWithFlameGame('deck size ${testCase['size']} with ${testCase['cards']} cards handles taps correctly', (game) async {
          bool tapped = false;
          final deck = CardDeck(
            CardPileModel(cards: _generateCards(testCase['cards'] as int)),
            onTap: () => tapped = true,
          )..size = testCase['size'] as Vector2;

          await game.ensureAdd(deck);

          deck.onTap?.call();
          
          expect(tapped, isTrue);
        });
      }
    });

    group('TapCallbacks mixin integration', () {
      testWithFlameGame('implements TapCallbacks correctly', (game) async {
        final deck = CardDeck(CardPileModel(cards: _generateCards(3)));
        
        expect(deck, isA<TapCallbacks>());
        
        await game.ensureAdd(deck);
        
        // Verify the component has tap callback functionality
        expect(deck.onTap, isNull); // No callback in this test
      });

      testWithFlameGame('tap callback can be null without issues', (game) async {
        final deck = CardDeck(CardPileModel(cards: _generateCards(3)));
        
        await game.ensureAdd(deck);
        
        // Should not throw when onTap is null
        expect(() => deck.onTap?.call(), returnsNormally);
        expect(deck.onTap, isNull);
      });
    });
  });
}