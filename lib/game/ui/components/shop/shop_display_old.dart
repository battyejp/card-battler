import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_card_coordinator.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component_old.dart';
import 'package:card_battler/game/ui/components/shop/shop_card_old.dart';
import 'package:flame/components.dart';

class ShopDisplayOld
    extends
        ReactivePositionComponentOld<CardListCoordinator<ShopCardCoordinator>> {
  ShopDisplayOld(super.coordinator);

  final double _cardHeightFactor = 0.38;
  final double _hSpacingFactor = 0.2;
  final int itemsPerRow = 3;
  final int numberOfRows = 2;

  @override
  void updateDisplay() {
    super.updateDisplay();

    _addCards();
  }

  void _addCards() {
    final cardWidth =
        size.x / (itemsPerRow + (itemsPerRow + 1) * _hSpacingFactor);
    final cardHeight = size.y * _cardHeightFactor;
    final totalWidth =
        itemsPerRow * cardWidth +
        (itemsPerRow - 1) * cardWidth * _hSpacingFactor;
    final totalHeight = numberOfRows * cardHeight;
    final hSpacing = cardWidth * _hSpacingFactor;
    final vSpacing = (size.y - totalHeight) / (numberOfRows + 1);
    final startX = (size.x - totalWidth) / 2;

    for (var row = 0; row < numberOfRows; row++) {
      for (var col = 0; col < itemsPerRow; col++) {
        final x = startX + col * (cardWidth + hSpacing);
        final y = vSpacing + row * (cardHeight + vSpacing);
        final cardIndex = row * itemsPerRow + col;

        // Check if we have enough cards to display
        if (cardIndex < coordinator.cardCoordinators.length) {
          final cardCoordinator = coordinator.cardCoordinators[cardIndex];
          final card = ShopCardOld(cardCoordinator)
            ..size = Vector2(cardWidth, cardHeight)
            ..position = Vector2(x, y);

          add(card);
        }
      }
    }
  }
}
