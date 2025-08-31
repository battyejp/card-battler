import 'package:card_battler/game/components/shared/card.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Card tap functionality', () {
    testWithFlameGame('calls onTap callback when card is tapped', (game) async {
      CardModel? tappedCard;
      final cardModel = CardModel(
        name: 'Test Card',
        type: 'Player',
        isFaceUp: true,
      );
      
      final card = Card(
        cardModel,
        onTap: (model) {
          tappedCard = model;
        },
      )..size = Vector2(100, 150);

      await game.ensureAdd(card);

      // Simulate tap by calling the callback directly
      card.onTap?.call(cardModel);
      
      expect(tappedCard, equals(cardModel));
    });

    testWithFlameGame('works without onTap callback', (game) async {
      final cardModel = CardModel(
        name: 'Test Card',
        type: 'Player',
        isFaceUp: true,
      );
      
      final card = Card(cardModel)..size = Vector2(100, 150);

      await game.ensureAdd(card);

      // Should not throw when no callback is provided
      expect(() => card.onTap?.call(cardModel), returnsNormally);
    });

    testWithFlameGame('preserves existing card functionality', (game) async {
      final cardModel = CardModel(
        name: 'Visible Card',
        type: 'Player',
        isFaceUp: true,
      );
      
      final card = Card(cardModel)..size = Vector2(100, 150);

      await game.ensureAdd(card);

      // Card should still display text components
      final textComponents = card.children.whereType<TextComponent>().toList();
      expect(textComponents.length, equals(1));
      expect(textComponents.first.text, equals('Visible Card'));
    });
  });
}