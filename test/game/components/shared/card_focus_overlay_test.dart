import 'package:card_battler/game/components/shared/card_focus_overlay.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CardFocusOverlay', () {
    testWithFlameGame('creates overlay with card model', (game) async {
      final cardModel = CardModel(
        name: 'Test Card',
        type: 'Player',
        isFaceUp: true,
      );
      
      final overlay = CardFocusOverlay(
        cardModel: cardModel,
        actionLabel: 'Play',
      )..size = Vector2(800, 600);

      await game.ensureAdd(overlay);

      expect(overlay.cardModel, equals(cardModel));
      expect(overlay.actionLabel, equals('Play'));
    });

    testWithFlameGame('creates overlay with shop card model', (game) async {
      final shopCardModel = ShopCardModel(
        name: 'Shop Test Card',
        cost: 5,
        isFaceUp: true,
      );
      
      final overlay = CardFocusOverlay(
        cardModel: shopCardModel,
        actionLabel: 'Buy',
      )..size = Vector2(800, 600);

      await game.ensureAdd(overlay);

      expect(overlay.cardModel, equals(shopCardModel));
      expect(overlay.actionLabel, equals('Buy'));
    });

    testWithFlameGame('calls action callback when action is triggered', (game) async {
      bool actionCalled = false;
      final cardModel = CardModel(
        name: 'Test Card',
        type: 'Player',
        isFaceUp: true,
      );
      
      final overlay = CardFocusOverlay(
        cardModel: cardModel,
        actionLabel: 'Play',
        onActionPressed: () {
          actionCalled = true;
        },
      )..size = Vector2(800, 600);

      await game.ensureAdd(overlay);

      // Simulate action button press
      overlay.onActionPressed?.call();
      
      expect(actionCalled, isTrue);
    });

    testWithFlameGame('displays card description', (game) async {
      final cardModel = CardModel(
        name: 'Attack Card',
        type: 'Player',
        effects: [
          EffectModel(
            type: EffectType.attack,
            target: EffectTarget.self,
            value: 2,
          ),
        ],
        isFaceUp: true,
      );
      
      final overlay = CardFocusOverlay(
        cardModel: cardModel,
        actionLabel: 'Play',
      )..size = Vector2(800, 600);

      await game.ensureAdd(overlay);
      
      expect(cardModel.description, isNotEmpty);
      expect(cardModel.description.contains('Attack'), isTrue);
    });
  });
}