import 'package:card_battler/game/models/player/card_pile_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/player/card_pile.dart';
import 'package:card_battler/game/components/shared/card.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  group('CardPile', () {
    group('with cards', () {
      final testCases = [
        {
          'deckSize': Vector2(100, 150),
          'cardSize': Vector2(50, 135),
          'cardPos': Vector2(25, 7.5),
        },
        {
          'deckSize': Vector2(200, 300),
          'cardSize': Vector2(100, 270),
          'cardPos': Vector2(50, 15),
        },
      ];
      for (final testCase in testCases) {
        testWithFlameGame('Pile child size and position for pile size ${testCase['deckSize']}', (game) async {
          final pile = CardPile(CardPileModel(numberOfCards: 3))..size = testCase['deckSize'] as Vector2;

          await game.ensureAdd(pile);

          final cards = pile.children.whereType<Card>().toList();
          expect(cards.length, 1);
          final card = cards.first;
          expect(card.size, testCase['cardSize']);
          expect(card.position, testCase['cardPos']);
          
          // Verify card count label is present
          final textComponents = pile.children.whereType<TextComponent>().toList();
          expect(textComponents.length, 1);
          final countLabel = textComponents.first;
          expect(countLabel.text, equals('3'));
        });
      }
    });

    group('empty pile', () {
      testWithFlameGame('shows "Empty" text when pile is empty', (game) async {
        final emptyPile = CardPile(CardPileModel.empty())..size = Vector2(100, 150);

        await game.ensureAdd(emptyPile);

        final textComponents = emptyPile.children.whereType<TextComponent>().toList();
        expect(textComponents.length, 1);
        
        final emptyText = textComponents.first;
        expect(emptyText.text, equals('Empty'));
        expect(emptyText.anchor, equals(Anchor.center));
        expect(emptyText.position, equals(Vector2(50, 75)));
      });

      testWithFlameGame('does not show cards when pile is empty', (game) async {
        final emptyPile = CardPile(CardPileModel.empty())..size = Vector2(100, 150);

        await game.ensureAdd(emptyPile);

        final cards = emptyPile.children.whereType<Card>().toList();
        expect(cards.length, 0);
      });

      testWithFlameGame('empty text centers correctly for different pile sizes', (game) async {
        final testCases = [
          {'size': Vector2(100, 150), 'expectedPos': Vector2(50, 75)},
          {'size': Vector2(200, 300), 'expectedPos': Vector2(100, 150)},
          {'size': Vector2(80, 120), 'expectedPos': Vector2(40, 60)},
        ];

        for (final testCase in testCases) {
          final emptyPile = CardPile(CardPileModel.empty())..size = testCase['size'] as Vector2;

          await game.ensureAdd(emptyPile);

          final textComponent = emptyPile.children.whereType<TextComponent>().first;
          expect(textComponent.position, equals(testCase['expectedPos']));

          game.remove(emptyPile);
        }
      });
    });

    group('card count label', () {
      testWithFlameGame('shows card count when pile has cards', (game) async {
        final testCases = [
          {'numberOfCards': 1, 'expectedText': '1'},
          {'numberOfCards': 5, 'expectedText': '5'},
          {'numberOfCards': 10, 'expectedText': '10'},
        ];

        for (final testCase in testCases) {
          final pile = CardPile(CardPileModel(numberOfCards: testCase['numberOfCards'] as int))
            ..size = Vector2(100, 150);

          await game.ensureAdd(pile);

          final textComponents = pile.children.whereType<TextComponent>().toList();
          expect(textComponents.length, 1);
          
          final countLabel = textComponents.first;
          expect(countLabel.text, equals(testCase['expectedText']));
          expect(countLabel.anchor, equals(Anchor.topRight));
          expect(countLabel.position, equals(Vector2(95, 5)));

          game.remove(pile);
        }
      });

      testWithFlameGame('does not show card count when pile is empty', (game) async {
        final emptyPile = CardPile(CardPileModel.empty())..size = Vector2(100, 150);

        await game.ensureAdd(emptyPile);

        final textComponents = emptyPile.children.whereType<TextComponent>().toList();
        expect(textComponents.length, 1);
        
        final textComponent = textComponents.first;
        expect(textComponent.text, equals('Empty'));
      });

      testWithFlameGame('count label positions correctly for different pile sizes', (game) async {
        final testCases = [
          {'size': Vector2(100, 150), 'expectedPos': Vector2(95, 5)},
          {'size': Vector2(200, 300), 'expectedPos': Vector2(195, 5)},
          {'size': Vector2(80, 120), 'expectedPos': Vector2(75, 5)},
        ];

        for (final testCase in testCases) {
          final pile = CardPile(CardPileModel(numberOfCards: 7))
            ..size = testCase['size'] as Vector2;

          await game.ensureAdd(pile);

          final textComponents = pile.children.whereType<TextComponent>().toList();
          final countLabel = textComponents.first;
          expect(countLabel.position, equals(testCase['expectedPos']));

          game.remove(pile);
        }
      });
    });
  });
}