import 'package:card_battler/game/coordinators/components/shop/shop_card_coordinator.dart';
import 'package:card_battler/game/ui/components/card/selectable_card.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' hide Card;

class ShopCard extends SelectableCard {
  ShopCard(ShopCardCoordinator super.coordinator) : _coordinator = coordinator;

  final ShopCardCoordinator _coordinator;

  @override
  String get buttonLabel => "Buy";

  @override
  void addTextComponent() {
    if (_coordinator.isFaceUp) {
      // Create name text component positioned higher to make room for cost
      createNameTextComponent(Vector2(size.x / 2, size.y / 2 - 15));
      add(nameTextComponent);

      // Add the cost text component
      var costTextComponent = TextComponent(
        text: "Cost: ${_coordinator.cost}",
        anchor: Anchor.center,
        position: Vector2(size.x / 2, size.y / 2 + 15),
        textRenderer: TextPaint(
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      );
      add(costTextComponent);
    } else {
      // Call parent implementation for face-down cards
      super.addTextComponent();
    }
  }
}
