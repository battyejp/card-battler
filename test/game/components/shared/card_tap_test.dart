import 'package:card_battler/game/components/shared/card.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:flame/events.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flame/components.dart';

void main() {
  group('Card tap functionality', () {
    group('TapCallbacks implementation', () {
      testWithFlameGame('implements TapCallbacks interface', (game) async {
        final cardModel = CardModel(name: 'Tappable Card', type: 'Test');
        final card = Card(cardModel);

        expect(card, isA<TapCallbacks>());
      });

      testWithFlameGame('creates without onTap callback (backward compatibility)', (game) async {
        final cardModel = CardModel(name: 'Basic Card', type: 'Test');
        final card = Card(cardModel)..size = Vector2(100, 150);

        await game.ensureAdd(card);

        expect(card.onTap, isNull);
        expect(card.cardModel, equals(cardModel));
      });

      testWithFlameGame('creates with onTap callback', (game) async {
        bool tapped = false;
        final cardModel = CardModel(name: 'Interactive Card', type: 'Test');
        final card = Card(
          cardModel,
          onTap: () => tapped = true,
        )..size = Vector2(100, 150);

        await game.ensureAdd(card);

        expect(card.onTap, isNotNull);
        expect(tapped, isFalse); // Not tapped yet
      });
    });

    group('tap event handling', () {
      testWithFlameGame('calls onTap callback when tapped', (game) async {
        bool tapped = false;
        final cardModel = CardModel(name: 'Test Card', type: 'Test');
        final card = Card(
          cardModel,
          onTap: () => tapped = true,
        )..size = Vector2(100, 150);

        await game.ensureAdd(card);

        // Simulate tap by calling the callback directly
        card.onTap?.call();

        expect(tapped, isTrue);
      });

      testWithFlameGame('does not throw when no onTap callback provided', (game) async {
        final cardModel = CardModel(name: 'Silent Card', type: 'Test');
        final card = Card(cardModel)..size = Vector2(100, 150);

        await game.ensureAdd(card);

        // Should not throw when calling onTap with null callback
        expect(() => card.onTap?.call(), returnsNormally);
      });

      testWithFlameGame('onTap callback can be called multiple times', (game) async {
        int tapCount = 0;
        final cardModel = CardModel(name: 'Multi-tap Card', type: 'Test');
        final card = Card(
          cardModel,
          onTap: () => tapCount++,
        )..size = Vector2(100, 150);

        await game.ensureAdd(card);

        // Simulate multiple taps
        card.onTap?.call();
        card.onTap?.call();
        card.onTap?.call();

        expect(tapCount, equals(3));
      });
    });

    group('integration with card display', () {
      testWithFlameGame('tap works with face up cards', (game) async {
        bool tapped = false;
        final cardModel = CardModel(
          name: 'Face Up Card', 
          type: 'Test', 
          isFaceUp: true,
        );
        final card = Card(
          cardModel,
          onTap: () => tapped = true,
        )..size = Vector2(100, 150);

        await game.ensureAdd(card);

        // Should display card name
        final textComponents = card.children.whereType<TextComponent>().toList();
        expect(textComponents.first.text, equals('Face Up Card'));

        // Should be tappable
        card.onTap?.call();
        expect(tapped, isTrue);
      });

      testWithFlameGame('tap works with face down cards', (game) async {
        bool tapped = false;
        final cardModel = CardModel(
          name: 'Hidden Card', 
          type: 'Test', 
          isFaceUp: false,
        );
        final card = Card(
          cardModel,
          onTap: () => tapped = true,
        )..size = Vector2(100, 150);

        await game.ensureAdd(card);

        // Should display "Back"
        final textComponents = card.children.whereType<TextComponent>().toList();
        expect(textComponents.first.text, equals('Back'));

        // Should still be tappable
        card.onTap?.call();
        expect(tapped, isTrue);
      });
    });
  });
}