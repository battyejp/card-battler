import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_card_coordinator.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:card_battler/game/ui/components/shop/shop_display.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ShopScene
    extends
        ReactivePositionComponent<CardListCoordinator<ShopCardCoordinator>> {
  ShopScene(super.coordinator);

  @override
  void updateDisplay() {
    super.updateDisplay();

    // Add text component with available credits
    final creditsText =
        TextComponent(
            text:
                'Credits: ${coordinator.cardCoordinators.isNotEmpty ? coordinator.cardCoordinators.first.creditsAvailable : 0}',
            textRenderer: TextPaint(
              style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 24),
            ),
          )
          ..anchor = Anchor.topCenter
          ..position = Vector2(0, 0 - size.y / 2 + 20);
    add(creditsText);

    // Add the shop display component
    final shopDisplay = ShopDisplay(coordinator)
      ..size = Vector2(size.x, size.y - creditsText.size.y - 20);
    add(shopDisplay);
  }
}
