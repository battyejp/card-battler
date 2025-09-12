import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/ui/components/card/card.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' hide Card;

class CardPile extends ReactivePositionComponent<CardListCoordinator> {
  final bool showNext;

  CardPile(super.coordinator, {required this.showNext});

  // @override
  // void onLoad() {
  //   updateDisplay();
  // }

  @override
  void updateDisplay() {
    super.updateDisplay();
    // Add components based on current model state
    if (coordinator.cardCoordinators.isEmpty) {
      _addEmptyText();
    } else {
      _addCard();
      _addCardCountLabel();
    }
  }

  void _addEmptyText() {
    final emptyText = TextComponent(
      text: 'Empty',
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2),
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
    add(emptyText);
  }

  void _addCard() {
    final cardWidth = size.x * 0.5;
    final cardHeight = size.y * 0.9;

    final card =
        Card(
            coordinator: showNext
                ? coordinator.cardCoordinators.first
                : coordinator.cardCoordinators.last,
          )
          ..size = Vector2(cardWidth, cardHeight)
          ..position = Vector2(
            (size.x - cardWidth) / 2,
            (size.y - cardHeight) / 2,
          );

    add(card);
  }

  void _addCardCountLabel() {
    final countText = TextComponent(
      text: '${coordinator.cardCoordinators.length}',
      anchor: Anchor.topRight,
      position: Vector2(size.x - 5, 5),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 16,
          color: Colors.yellow,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(countText);
  }
}
