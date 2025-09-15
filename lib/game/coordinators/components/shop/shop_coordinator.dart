import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_display_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_inventory_coordinator.dart';

class ShopCoordinator {
  //TODO should theses just be lists like in player
  final ShopDisplayCoordinator _displayCoordinator;
  final ShopInventoryCoordinator _inventoryCoordinator;

  Function(int cost)? onCardBought;

  ShopCoordinator({
    required ShopDisplayCoordinator displayCoordinator,
    required ShopInventoryCoordinator inventoryCoordinator,
  }) : _inventoryCoordinator = inventoryCoordinator,
       _displayCoordinator = displayCoordinator {
    _addCardsToDisplayFromInventory(6);
  }

  ShopDisplayCoordinator get displayCoordinator => _displayCoordinator;
  ShopInventoryCoordinator get inventoryCoordinator => _inventoryCoordinator;

  void _addCardsToDisplayFromInventory(int numberOfCards) {
    var cards = _inventoryCoordinator.shopCardCoordinators.take(numberOfCards);
    _inventoryCoordinator.shopCardCoordinators.removeWhere(
      (card) => cards.contains(card),
    );
    _displayCoordinator.shopCardCoordinators.addAll(cards);

    for (var card in cards) {
      card.onCardPlayed = onCardPlayed;
    }
  }

  void onCardPlayed(CardCoordinator cardCoordinator) {
    cardCoordinator.onCardPlayed = null;
    _displayCoordinator.shopCardCoordinators.remove(cardCoordinator);

    var cost = cardCoordinator is ShopCardCoordinator
        ? (cardCoordinator).cost
        : 0;
    onCardBought?.call(cost);
  }
}
