import 'package:card_battler/game/coordinators/components/shop/shop_card_coordinator.dart';
import 'package:card_battler/game/ui/components/card/card_sprite.dart';
import 'package:card_battler/game/ui/components/common/flat_button.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ShopCard extends CardSprite {
  ShopCard(ShopCardCoordinator super.coordinator, super.isMini)
    : _coordinator = coordinator;

  final ShopCardCoordinator _coordinator;
  final double _buttonHeight = 60;

  @override
  void onLoad() {
    super.onLoad();

    if (_coordinator.isFaceUp) {
      final costText = TextComponent(
        text: '\$${_coordinator.cost}',
        position: Vector2(sprite!.srcSize.x / 2, 20),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(fontSize: 36, color: Color(0xFFFFD700)),
        ),
      );

      add(costText);

      // TODO look at hardcoded sizes
      final button = FlatButton(
        'Buy',
        size: Vector2(sprite!.srcSize.x, _buttonHeight),
        position: Vector2(sprite!.srcSize.x / 2, sprite!.srcSize.y + _buttonHeight / 2 + 10),
        onReleased: () {
          if (!_coordinator.isActionDisabled()) {
            coordinator.handleCardPlayed();
          }
        },
        disabled: _coordinator.isActionDisabled(),
      );
      add(button);
    }
  }
}
