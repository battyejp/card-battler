import 'package:card_battler/game/models/player/card_pile_model.dart';
import 'package:flame/components.dart';
import 'package:card_battler/game/components/shared/card.dart';
import 'package:flutter/material.dart' hide Card;

class CardPile extends PositionComponent {
  final CardPileModel model;

  CardPile(this.model);

  @override
  bool get debugMode => true;

  @override
  onLoad() {
    if (model.hasNoCards) {
      _addEmptyText();
    } else {
      _addTopCard();
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

  void _addTopCard() {
    final cardWidth = size.x * 0.5;
    final cardHeight = size.y * 0.9;

    final card = Card(model.allCards.first)
      ..size = Vector2(cardWidth, cardHeight)
      ..position = Vector2((size.x - cardWidth) / 2, (size.y - cardHeight) / 2);

    add(card);
  }

  void _addCardCountLabel() {
    final countText = TextComponent(
      text: '${model.allCards.length}',
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

  /// Refreshes the display of the card pile to reflect model changes
  void refreshDisplay() {
    // Clear existing components
    removeWhere((component) => component is Card || component is TextComponent);
    
    // Re-add components based on current model state
    if (model.hasNoCards) {
      _addEmptyText();
    } else {
      _addTopCard();
      _addCardCountLabel();
    }
  }
}