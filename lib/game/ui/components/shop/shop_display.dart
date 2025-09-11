import 'package:card_battler/game/coordinators/components/shop/shop_display_coordinator.dart';
import 'package:card_battler/game/ui/components/shop/shop_card.dart';
import 'package:flame/components.dart';

class ShopDisplay extends PositionComponent {
  // final CardInteractionService? _cardInteractionService;
  // final CardSelectionService? _cardSelectionService;

  final ShopDisplayCoordinator _coordinator;

  ShopDisplay({required ShopDisplayCoordinator shopDisplayCoordinator})
    : _coordinator = shopDisplayCoordinator;

  final double _cardHeightFactor = 0.38;
  final double _hSpacingFactor = 0.2;

  @override
  void onLoad() {
    _addCards();
  }

  void _addCards() {
    final cardWidth =
        size.x /
        (_coordinator.itemsPerRow +
            (_coordinator.itemsPerRow + 1) * _hSpacingFactor);
    final cardHeight = size.y * _cardHeightFactor;
    final totalWidth =
        _coordinator.itemsPerRow * cardWidth +
        (_coordinator.itemsPerRow - 1) * cardWidth * _hSpacingFactor;
    final totalHeight = _coordinator.numberOfRows * cardHeight;
    final hSpacing = cardWidth * _hSpacingFactor;
    final vSpacing = (size.y - totalHeight) / (_coordinator.numberOfRows + 1);
    final startX = (size.x - totalWidth) / 2;

    for (int row = 0; row < _coordinator.numberOfRows; row++) {
      for (int col = 0; col < _coordinator.itemsPerRow; col++) {
        final x = startX + col * (cardWidth + hSpacing);
        final y = vSpacing + row * (cardHeight + vSpacing);
        final cardIndex = row * _coordinator.itemsPerRow + col;

        // Check if we have enough cards to display
        if (cardIndex < _coordinator.shopCardCoordinators.length) {
          final cardCoordinator = _coordinator.shopCardCoordinators[cardIndex];
          final card = ShopCard(cardCoordinator)
            ..size = Vector2(cardWidth, cardHeight)
            ..position = Vector2(x, y);

          add(card);
        }
      }
    }
  }
}
