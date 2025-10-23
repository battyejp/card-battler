import 'package:card_battler/game/coordinators/components/shop/shop_card_coordinator.dart';
import 'package:card_battler/game/ui/components/card/card_sprite.dart';
import 'package:card_battler/game/ui/components/common/flat_button.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ShopCard extends PositionComponent {
  ShopCard(ShopCardCoordinator coordinator) : _coordinator = coordinator;

  final ShopCardCoordinator _coordinator;

  // Border sizes - bottom border is twice as large for button
  static const double borderSize = 15.0;
  static const double bottomBorderSize = borderSize * 2;

  @override
  void onMount() {
    super.onMount();

    if (_coordinator.isFaceUp) {
      // Add dark semi-transparent background border
      final background = RectangleComponent(
        size: size,
        paint: Paint()..color = const Color.fromARGB(195, 0, 0, 0),
        position: Vector2.zero(),
      )..anchor = Anchor.topLeft;

      add(background);

      // Calculate card sprite area (excluding borders)
      final cardSpriteWidth = size.x - (borderSize * 2);
      final cardSpriteHeight = size.y - borderSize - bottomBorderSize;

      // Add card sprite with offset for top and side borders
      final cardSprite = CardSprite(_coordinator)
        ..size = Vector2(cardSpriteWidth, cardSpriteHeight)
        ..anchor = Anchor.topLeft
        ..position = Vector2(borderSize, borderSize);

      add(cardSprite);

      // Cost text positioned on top of the card image
      final costText = TextComponent(
        text: '\$${_coordinator.cost}',
        position: Vector2(size.x / 2, borderSize + cardSpriteHeight * 0.08),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(fontSize: 36, color: Color(0xFFFFD700)),
        ),
      );

      add(costText);

      // Button positioned in the bottom border area
      const buttonHeight = bottomBorderSize * 0.8;
      final button = FlatButton(
        'Buy',
        size: Vector2(cardSpriteWidth * 0.9, buttonHeight),
        position: Vector2(size.x / 2, size.y - bottomBorderSize / 2),
        onReleased: () {
          if (!_coordinator.isActionDisabled()) {
            _coordinator.handleCardPlayed();
          }
        },
        disabled: _coordinator.isActionDisabled(),
      );
      add(button);
    }
  }
}
