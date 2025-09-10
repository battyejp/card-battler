import 'package:card_battler/game_legacy/components/shared/reactive_position_component.dart';
import 'package:card_battler/game_legacy/services/shop/shop_coordinator.dart';
import 'package:card_battler/game_legacy/services/card/card_interaction_service.dart';
import 'package:card_battler/game_legacy/services/card/card_selection_service.dart';
import 'package:flame/components.dart';
import 'package:card_battler/game_legacy/components/shop/shop_card.dart';

class Shop extends ReactivePositionComponent<ShopCoordinator> {
  final CardInteractionService? _cardInteractionService;
  final CardSelectionService? _cardSelectionService;
  
  Shop(
    super.model, 
    {
      CardInteractionService? cardInteractionService,
      CardSelectionService? cardSelectionService,
    }
  ) : _cardInteractionService = cardInteractionService,
      _cardSelectionService = cardSelectionService;

  static const double cardHeightFactor = 0.38;
  static const double hSpacingFactor = 0.2;

  @override
  void updateDisplay() {
    super.updateDisplay();
    _addCards();  
  }

  void _addCards() {
    final cardWidth = size.x / (model.numberOfColumns + (model.numberOfColumns + 1) * hSpacingFactor);
    final cardHeight = size.y * cardHeightFactor;
    final totalWidth = model.numberOfColumns * cardWidth + (model.numberOfColumns - 1) * cardWidth * hSpacingFactor;
    final totalHeight = model.numberOfRows * cardHeight;
    final hSpacing = cardWidth * hSpacingFactor;
    final vSpacing = (size.y - totalHeight) / (model.numberOfRows + 1);
    final startX = (size.x - totalWidth) / 2;

    for (int row = 0; row < model.numberOfRows; row++) {
      for (int col = 0; col < model.numberOfColumns; col++) {
        final x = startX + col * (cardWidth + hSpacing);
        final y = vSpacing + row * (cardHeight + vSpacing);
        final cardIndex = row * model.numberOfColumns + col;

        // Check if we have enough cards to display
        if (cardIndex < model.selectableCards.length) {
          final cardModel = model.selectableCards[cardIndex];
          final card = ShopCard(
            cardModel,
            cardInteractionService: _cardInteractionService,
            cardSelectionService: _cardSelectionService,
          )
            ..size = Vector2(cardWidth, cardHeight)
            ..position = Vector2(x, y);

          add(card);
        }
      }
    }
  }
}