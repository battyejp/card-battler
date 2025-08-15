import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/shared/card.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  group('Card', () {
    group('constructor and initialization', () {
      testWithFlameGame('creates with CardModel parameter', (game) async {
        final cardModel = CardModel(name: 'Test Card', cost: 5);
        final card = Card(cardModel);

        expect(card.cardModel, equals(cardModel));
        expect(card.cardModel.name, equals('Test Card'));
        expect(card.cardModel.cost, equals(5));
      });

      final testCases = [
        {
          'name': 'Fire Ball',
          'cost': 3,
          'size': Vector2(100, 150),
          'pos': Vector2(10, 20)
        },
        {
          'name': 'Lightning Strike',
          'cost': 8,
          'size': Vector2(200, 300),
          'pos': Vector2(0, 0)
        },
        {
          'name': 'Free Spell',
          'cost': 0,
          'size': Vector2(80, 120),
          'pos': Vector2(50, 75)
        },
      ];

      for (final testCase in testCases) {
        testWithFlameGame(
            'creates with different parameters: ${testCase['name']}',
            (game) async {
          final cardModel = CardModel(
            name: testCase['name'] as String,
            cost: testCase['cost'] as int,
          );
          final card = Card(cardModel)
            ..size = testCase['size'] as Vector2
            ..position = testCase['pos'] as Vector2;

          await game.ensureAdd(card);

          expect(game.children.contains(card), isTrue);
          expect(card.size, testCase['size']);
          expect(card.position, testCase['pos']);
          expect(card.cardModel.name, testCase['name']);
          expect(card.cardModel.cost, testCase['cost']);
        });
      }
    });

    group('onLoad functionality', () {
      testWithFlameGame('creates text component on load', (game) async {
        final cardModel = CardModel(name: 'Magic Missile', cost: 2);
        final card = Card(cardModel)..size = Vector2(100, 150);

        await game.ensureAdd(card);

        expect(card.children.length, equals(1));
        expect(card.children.first, isA<TextComponent>());
        
        final textComponent = card.children.first as TextComponent;
        expect(textComponent.text, equals('Magic Missile - Cost: 2'));
        expect(textComponent.anchor, equals(Anchor.center));
        expect(textComponent.position, equals(Vector2(50, 75)));
      });

      testWithFlameGame('text component updates with different card data', (game) async {
        final cardModel = CardModel(name: 'Heal', cost: 1);
        final card = Card(cardModel)..size = Vector2(80, 120);

        await game.ensureAdd(card);

        final textComponent = card.children.first as TextComponent;
        expect(textComponent.text, equals('Heal - Cost: 1'));
        expect(textComponent.position, equals(Vector2(40, 60)));
      });

      testWithFlameGame('handles empty card name', (game) async {
        final cardModel = CardModel(name: '', cost: 0);
        final card = Card(cardModel)..size = Vector2(100, 150);

        await game.ensureAdd(card);

        final textComponent = card.children.first as TextComponent;
        expect(textComponent.text, equals(' - Cost: 0'));
      });
    });

    group('face up/down functionality', () {
      testWithFlameGame('card is face up by default', (game) async {
        final cardModel = CardModel(name: 'Test Card', cost: 3);
        final card = Card(cardModel)..size = Vector2(100, 150);

        expect(cardModel.isFaceUp, isTrue);

        await game.ensureAdd(card);

        final textComponent = card.children.first as TextComponent;
        expect(textComponent.text, equals('Test Card - Cost: 3'));
      });

      testWithFlameGame('card shows card details when face up', (game) async {
        final cardModel = CardModel(name: 'Fire Ball', cost: 5, isFaceUp: true);
        final card = Card(cardModel)..size = Vector2(100, 150);

        expect(cardModel.isFaceUp, isTrue);

        await game.ensureAdd(card);

        final textComponent = card.children.first as TextComponent;
        expect(textComponent.text, equals('Fire Ball - Cost: 5'));
      });

      testWithFlameGame('card shows "Back" when face down', (game) async {
        final cardModel = CardModel(name: 'Secret Card', cost: 7, isFaceUp: false);
        final card = Card(cardModel)..size = Vector2(100, 150);

        expect(cardModel.isFaceUp, isFalse);

        await game.ensureAdd(card);

        final textComponent = card.children.first as TextComponent;
        expect(textComponent.text, equals('Back'));
      });

      testWithFlameGame('face down card with different card data still shows "Back"', (game) async {
        final testCases = [
          {'name': 'Card A', 'cost': 0},
          {'name': 'Expensive Card', 'cost': 999},
          {'name': '', 'cost': 5},
        ];

        for (final testCase in testCases) {
          final cardModel = CardModel(
            name: testCase['name'] as String,
            cost: testCase['cost'] as int,
            isFaceUp: false,
          );
          final card = Card(cardModel)..size = Vector2(100, 150);

          await game.ensureAdd(card);

          final textComponent = card.children.first as TextComponent;
          expect(textComponent.text, equals('Back'));

          game.remove(card);
        }
      });
    });
  });
}