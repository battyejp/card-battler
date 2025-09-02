import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/shared/card/card.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  group('Card', () {
    group('constructor and initialization', () {
      testWithFlameGame('creates with CardModel parameter', (game) async {
        final cardModel = CardModel(name: 'Test Card', type: 'Player');
        final card = Card(cardModel);

        expect(card.cardModel, equals(cardModel));
        expect(card.cardModel.name, equals('Test Card'));
        expect(card.cardModel.type, equals('Player'));
      });

      final testCases = [
        {
          'name': 'Fire Ball',
          'type': 'Spell',
          'size': Vector2(100, 150),
          'pos': Vector2(10, 20)
        },
        {
          'name': 'Lightning Strike',
          'type': 'Spell',
          'size': Vector2(200, 300),
          'pos': Vector2(0, 0)
        },
        {
          'name': 'Basic Card',
          'type': 'Action',
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
            type: testCase['type'] as String,
          );
          final card = Card(cardModel)
            ..size = testCase['size'] as Vector2
            ..position = testCase['pos'] as Vector2;

          await game.ensureAdd(card);

          expect(card.cardModel.name, equals(testCase['name']));
          expect(card.cardModel.type, equals(testCase['type']));
          expect(card.size, equals(testCase['size']));
          expect(card.position, equals(testCase['pos']));
        });
      }
    });

    group('onLoad functionality', () {
      testWithFlameGame('creates text components on load when face up', (game) async {
        final cardModel = CardModel(name: 'Magic Missile', type: 'Spell', isFaceUp: true);
        final card = Card(cardModel)..size = Vector2(100, 150);

        await game.ensureAdd(card);

        expect(card.children.length, equals(2)); // 1 text component + 1 button
        expect(card.children.whereType<TextComponent>().length, equals(1));
        
        final textComponent = card.children.whereType<TextComponent>().first;
        
        expect(textComponent.text, equals('Magic Missile'));
        expect(textComponent.anchor, equals(Anchor.center));
      });

      testWithFlameGame('text components update with different card data', (game) async {
        final cardModel = CardModel(name: 'Heal', type: 'Spell', isFaceUp: true);
        final card = Card(cardModel)..size = Vector2(80, 120);

        await game.ensureAdd(card);

        final textComponent = card.children.whereType<TextComponent>().first;
        
        expect(textComponent.text, equals('Heal'));
      });

      testWithFlameGame('handles empty card name', (game) async {
        final cardModel = CardModel(name: '', type: 'Unknown', isFaceUp: true);
        final card = Card(cardModel)..size = Vector2(50, 75);

        await game.ensureAdd(card);

        final textComponent = card.children.whereType<TextComponent>().first;
        
        expect(textComponent.text, equals(''));
      });
    });

    group('face up/down functionality', () {
      testWithFlameGame('card is face down by default', (game) async {
        final cardModel = CardModel(name: 'Test Card', type: 'Player');
        final card = Card(cardModel)..size = Vector2(100, 150);

        await game.ensureAdd(card);

        expect(card.children.length, equals(2));
        expect(card.cardModel.isFaceUp, equals(false));
      });

      testWithFlameGame('card shows card name when face up', (game) async {
        final cardModel = CardModel(name: 'Fire Ball', type: 'Spell', isFaceUp: true);
        final card = Card(cardModel)..size = Vector2(100, 150);

        await game.ensureAdd(card);

        expect(card.children.length, equals(2));
        
        final textComponent = card.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('Fire Ball'));
      });

      testWithFlameGame('card shows back when face down', (game) async {
        final cardModel = CardModel(name: 'Secret Card', type: 'Spell', isFaceUp: false);
        final card = Card(cardModel)..size = Vector2(100, 150);

        await game.ensureAdd(card);

        expect(card.children.length, equals(2));
        
        final textComponent = card.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('Back'));
      });
    });

    group('render functionality', () {
      testWithFlameGame('card renders without error', (game) async {
        final cardModel = CardModel(name: 'Render Test', type: 'Test', isFaceUp: true);
        final card = Card(cardModel)..size = Vector2(100, 150);

        await game.ensureAdd(card);

        expect(card.children.length, equals(2));
        expect(card.cardModel.name, equals('Render Test'));
      });
    });
  });
}
