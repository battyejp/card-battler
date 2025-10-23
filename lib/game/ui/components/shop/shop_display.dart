import 'package:card_battler/game/coordinators/components/shop/shop_display_coordinator.dart';
import 'package:card_battler/game/game_variables.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:card_battler/game/ui/components/shop/shop_card.dart';
import 'package:flame/components.dart';

class ShopDisplay extends ReactivePositionComponent<ShopDisplayCoordinator> {
  ShopDisplay(super.coordinator);

  final double _spacing = 0.4;

  // Calculate the actual card dimensions including borders
  static double _getCardWidthWithBorder(double scale) =>
      (GameVariables.originalCardSizeWidth * scale) + (ShopCard.borderSize * 2);

  static double _getCardHeightWithBorder(double scale) =>
      (GameVariables.originalCardSizeHeight * scale) +
      ShopCard.borderSize +
      ShopCard.bottomBorderSize;

  @override
  void updateDisplay() {
    super.updateDisplay();

    _addCards();
  }

  void _addCards() {
    final itemsPerRow = coordinator.itemsPerRow;
    final numberOfRows = coordinator.numberOfRows;

    // Calculate scale that accounts for borders
    // Total horizontal borders: borderSize * 2 per card * itemsPerRow
    final totalHorizontalBorders = ShopCard.borderSize * 2 * itemsPerRow;
    final totalVerticalBorders =
        (ShopCard.borderSize + ShopCard.bottomBorderSize) * numberOfRows;

    // Available space for card images (excluding borders)
    final availableWidthForCards = size.x - totalHorizontalBorders;
    final availableHeightForCards = size.y - totalVerticalBorders;

    // Calculate scale based on available space for card images
    final widthScale =
        availableWidthForCards /
        (GameVariables.originalCardSizeWidth * itemsPerRow * (1 + _spacing));

    final heightScale =
        availableHeightForCards /
        (GameVariables.originalCardSizeHeight * numberOfRows * (1 + _spacing));

    // Use the smaller scale to ensure everything fits
    final scale = widthScale < heightScale ? widthScale : heightScale;

    // Calculate actual card dimensions including borders
    final cardWidth = _getCardWidthWithBorder(scale);
    final cardHeight = _getCardHeightWithBorder(scale);

    // Calculate spacing between card edges (not including the card itself)
    final cardImageWidth = GameVariables.originalCardSizeWidth * scale;
    final cardImageHeight = GameVariables.originalCardSizeHeight * scale;
    final horizontalGap = cardImageWidth * _spacing;
    final verticalGap = cardImageHeight * _spacing;

    // Total spacing between cards
    final horizontalSpacing = cardWidth + horizontalGap;
    final verticalSpacing = cardHeight + verticalGap;

    // Calculate total grid dimensions
    final totalGridWidth =
        (cardWidth * itemsPerRow) + (horizontalGap * (itemsPerRow - 1));
    final totalGridHeight =
        (cardHeight * numberOfRows) + (verticalGap * (numberOfRows - 1));

    // Center the grid
    final leftMargin = (size.x - totalGridWidth) / 2;
    final topMargin = (size.y - totalGridHeight) / 2;

    for (var row = 0; row < numberOfRows; row++) {
      for (var col = 0; col < itemsPerRow; col++) {
        final cardIndex = row * itemsPerRow + col;

        // Check if we have enough cards to display
        if (cardIndex < coordinator.cardCoordinators.length) {
          final cardCoordinator = coordinator.cardCoordinators[cardIndex];

          final card = ShopCard(cardCoordinator)
            ..size = Vector2(cardWidth, cardHeight)
            ..anchor = Anchor.topLeft
            ..position = Vector2(
              leftMargin + col * horizontalSpacing,
              topMargin + row * verticalSpacing,
            );

          add(card);
        }
      }
    }
  }
}
