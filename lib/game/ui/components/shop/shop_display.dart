import 'package:card_battler/game/coordinators/components/shop/shop_display_coordinator.dart';
import 'package:card_battler/game/game_variables.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:card_battler/game/ui/components/shop/shop_card.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';

class ShopDisplay extends ReactivePositionComponent<ShopDisplayCoordinator> {
  ShopDisplay(super.coordinator);

  final double _spacing = 0.4;

  @override
  void updateDisplay() {
    super.updateDisplay();

    _addCards();
  }

  void _addCards() {
    final itemsPerRow = coordinator.itemsPerRow;
    final numberOfRows = coordinator.numberOfRows;
    final scale = size.x / (GameVariables.originalCardSizeWidth * 2.5);
    final cardWidth = GameVariables.originalCardSizeWidth * scale;
    final cardHeight = GameVariables.originalCardSizeHeight * scale;

    // Spacing between cards
    final horizontalSpacing = cardWidth * (1 + _spacing);
    final verticalSpacing = cardHeight * (1 + _spacing);

    // Calculate total grid width and center it
    final totalGridWidth = cardWidth + (itemsPerRow - 1) * horizontalSpacing;
    final leftMargin = (size.x - totalGridWidth) / 2;

    // Start position
    final startX = leftMargin + cardWidth / 2;
    final startY = cardHeight * scale / 2 + cardHeight / 2;

    for (var row = 0; row < numberOfRows; row++) {
      for (var col = 0; col < itemsPerRow; col++) {
        final cardIndex = row * itemsPerRow + col;

        // Check if we have enough cards to display
        if (cardIndex < coordinator.cardCoordinators.length) {
          final cardCoordinator = coordinator.cardCoordinators[cardIndex];

          final card = ShopCard(cardCoordinator)
            ..size = Vector2(cardWidth, cardHeight)
            ..position = Vector2(
              startX + col * horizontalSpacing,
              startY + row * verticalSpacing,
            );

          add(card);
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = const Color.fromARGB(255, 193, 6, 124);
    canvas.drawRect(size.toRect(), paint);
  }
}
