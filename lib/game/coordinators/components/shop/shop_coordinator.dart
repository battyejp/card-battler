import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_card_coordinator.dart';

class ShopCoordinator {
  final CardListCoordinator<ShopCardCoordinator> _displayCoordinators;
  final CardListCoordinator<ShopCardCoordinator> _inventoryCoordinators;

  Function(ShopCardCoordinator shopCardCoordinator)? onCardBought;

  ShopCoordinator({
    required CardListCoordinator<ShopCardCoordinator> displayCoordinators,
    required CardListCoordinator<ShopCardCoordinator> inventoryCoordinators,
  }) : _inventoryCoordinators = inventoryCoordinators,
       _displayCoordinators = displayCoordinators {
    _addCardsToDisplayFromInventory(6);
  }

  CardListCoordinator<ShopCardCoordinator> get displayCoordinator =>
      _displayCoordinators;

  void _addCardsToDisplayFromInventory(int numberOfCards) {
    var drawnCards = _inventoryCoordinators.drawCards(numberOfCards);
    for (var card in drawnCards) {
      card.onCardPlayed = onCardPlayed;
    }

    _displayCoordinators.addCards(drawnCards);
  }

  void onCardPlayed(CardCoordinator cardCoordinator) {
    cardCoordinator.onCardPlayed = null;
    var shopCardCoordinator = cardCoordinator as ShopCardCoordinator;
    _displayCoordinators.removeCard(shopCardCoordinator);
    onCardBought?.call(shopCardCoordinator);
  }
}
