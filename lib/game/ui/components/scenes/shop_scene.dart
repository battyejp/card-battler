import 'package:card_battler/game/coordinators/components/scenes/shop_scene_coordinator.dart';
import 'package:card_battler/game/ui/components/shop/shop_display.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ShopScene extends PositionComponent {
  ShopScene(ShopSceneCoordinator coordinator) : _coordinator = coordinator;

  final ShopSceneCoordinator _coordinator;

  final double _titleHeight = 80;

  @override
  void onMount() {
    super.onMount();
    removeWhere((component) => true);

    // Add text component with available credits
    final creditsText =
        TextComponent(
            text:
                'Credits: ${_coordinator.playerCoordinator.playerInfoCoordinator.credits}',
            textRenderer: TextPaint(
              style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 24),
            ),
          )
          ..anchor = Anchor.topCenter
          ..position = Vector2(0, 0 - size.y / 2 + _titleHeight / 2);
    add(creditsText);

    // Add the shop display component
    final shopDisplay = ShopDisplay(_coordinator.shopDisplayCoordinator)
      ..size = Vector2(size.x, size.y - creditsText.size.y - _titleHeight);
    add(shopDisplay);
  }
}
