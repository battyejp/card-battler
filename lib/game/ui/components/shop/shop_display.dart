import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_card_coordinator.dart';
import 'package:card_battler/game/game_variables.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:card_battler/game/ui/components/shop/shop_card.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class ShopDisplay
    extends
        ReactivePositionComponent<CardListCoordinator<ShopCardCoordinator>> {
  ShopDisplay(super.coordinator);

  final int itemsPerRow = 2;
  final int numberOfRows = 3;
  final double _spacing = 0.4;

  @override
  void updateDisplay() {
    super.updateDisplay();

    _addCards();
  }

  void _addCards() {
    final cardWidth = GameVariables.defaultCardSizeWidth * _spacing;
    final cardHeight = GameVariables.defaultCardSizeHeight * _spacing;
    final totalWidth = itemsPerRow * cardWidth;
    final totalHeight = numberOfRows * cardHeight;
    final hSpacing = (size.x - totalWidth) / (itemsPerRow + 1);
    final vSpacing = (size.y - totalHeight) / (numberOfRows + 1);

    for (var row = 0; row < numberOfRows; row++) {
      for (var col = 0; col < itemsPerRow; col++) {
        final cardIndex = row * itemsPerRow + col;

        // Check if we have enough cards to display
        if (cardIndex < coordinator.cardCoordinators.length) {
          final cardCoordinator = coordinator.cardCoordinators[cardIndex];
          final x = col * cardWidth;
          final y = row * cardHeight;

          final card = ShopCard(cardCoordinator, false)
            ..position = Vector2(
              x - size.x / 2 + cardWidth / 2 + hSpacing * (col + 1),
              y - size.y / 2 + cardHeight / 2 + vSpacing * (row + 1),
            )
            ..scale = Vector2.all(_spacing);

          add(card);
        }
      }
    }
  }
}
