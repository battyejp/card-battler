import 'package:card_battler/game/coordinators/components/cards/cards_coordinator.dart';
import 'package:card_battler/game/ui/components/card/card.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' hide Card;

class CardPile extends PositionComponent {
  final bool showNext;
  final CardsCoordinator _coordinator;

  CardPile({required this.showNext, required CardsCoordinator coordinator})
      : _coordinator = coordinator;

  //TODO temp to get working
  @override void onLoad() {
    updateDisplay();
  }

  void updateDisplay() {
    // Add components based on current model state
    if (_coordinator.cards.hasNoCards) {
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
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
    add(emptyText);
  }

  void _addCard() {
    final cardWidth = size.x * 0.5;
    final cardHeight = size.y * 0.9;

    final card = Card(showNext ? _coordinator.cards.allCards.first : _coordinator.cards.allCards.last)
      ..size = Vector2(cardWidth, cardHeight)
      ..position = Vector2((size.x - cardWidth) / 2, (size.y - cardHeight) / 2);

    add(card);
  }

  void _addCardCountLabel() {
    final countText = TextComponent(
      text: '${_coordinator.cards.allCards.length}',
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