import 'package:card_battler/game/components/player/card_pile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/player/player.dart';
import 'package:card_battler/game/components/player/hand.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  group('Player', () {
    group('layout and positioning', () {
      final testCases = [
        {
          'size': Vector2(300, 100),
          'deck': {'size': Vector2(60, 100), 'pos': Vector2(0, 0)},
          'hand': {'size': Vector2(180, 100), 'pos': Vector2(60, 0)},
          'discard': {'size': Vector2(60, 100), 'pos': Vector2(240, 0)},
        },
        {
          'size': Vector2(400, 200),
          'deck': {'size': Vector2(80, 200), 'pos': Vector2(0, 0)},
          'hand': {'size': Vector2(240, 200), 'pos': Vector2(80, 0)},
          'discard': {'size': Vector2(80, 200), 'pos': Vector2(320, 0)},
        },
      ];

      for (final testCase in testCases) {
        testWithFlameGame(
          'Player children sizes and positions for size ${testCase['size']}',
          (game) async {
            final player = Player()..size = testCase['size'] as Vector2;

            await game.ensureAdd(player);

            final cardPiles = player.children.whereType<CardPile>().toList();
            final hand = player.children.whereType<Hand>().first;
            
            // First CardPile is the deck (leftmost)
            final deck = cardPiles.first;
            // Second CardPile is the discard (rightmost)
            final discard = cardPiles.last;
            
            final deckCase = testCase['deck'] as Map<String, Vector2>;
            final handCase = testCase['hand'] as Map<String, Vector2>;
            final discardCase = testCase['discard'] as Map<String, Vector2>;
            
            expect(deck.size, deckCase['size']);
            expect(deck.position, deckCase['pos']);
            expect(hand.size, handCase['size']);
            expect(hand.position, handCase['pos']);
            expect(discard.size, discardCase['size']);
            expect(discard.position, discardCase['pos']);
            
            // Verify we have exactly 2 CardPiles and 1 Hand
            expect(player.children.whereType<CardPile>().length, 2);
            expect(player.children.whereType<Hand>().length, 1);
          },
        );
      }
    });

    group('card pile contents', () {
      testWithFlameGame('deck starts with 7 cards and discard is empty', (game) async {
        final player = Player()..size = Vector2(300, 100);

        await game.ensureAdd(player);

        final cardPiles = player.children.whereType<CardPile>().toList();
        final deck = cardPiles.first;
        final discard = cardPiles.last;
        
        // Deck should have 7 cards
        expect(deck.model.allCards.length, equals(7));
        expect(deck.model.hasNoCards, isFalse);
        
        // Discard should be empty
        expect(discard.model.allCards.length, equals(0));
        expect(discard.model.hasNoCards, isTrue);
      });

      testWithFlameGame('deck cards have correct properties', (game) async {
        final player = Player()..size = Vector2(300, 100);

        await game.ensureAdd(player);

        final deck = player.children.whereType<CardPile>().first;
        
        for (int i = 0; i < deck.model.allCards.length; i++) {
          final card = deck.model.allCards[i];
          expect(card.name, equals('Card ${i + 1}'));
          expect(card.cost, equals(1));
          expect(card.isFaceUp, isFalse);
        }
      });

      testWithFlameGame('card piles show correct count labels', (game) async {
        final player = Player()..size = Vector2(300, 100);

        await game.ensureAdd(player);

        final cardPiles = player.children.whereType<CardPile>().toList();
        final deck = cardPiles.first;
        final discard = cardPiles.last;
        
        // Deck should show count of 7
        final deckTextComponents = deck.children.whereType<TextComponent>().toList();
        expect(deckTextComponents.length, 1);
        expect(deckTextComponents.first.text, equals('7'));
        
        // Discard should show "Empty" (no count label)
        final discardTextComponents = discard.children.whereType<TextComponent>().toList();
        expect(discardTextComponents.length, 1);
        expect(discardTextComponents.first.text, equals('Empty'));
      });
    });
  });
}
