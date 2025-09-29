import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_card_coordinator.dart';

class ShopSceneCoordinator {
  ShopSceneCoordinator({
    required CardListCoordinator<ShopCardCoordinator> displayCoordinators,
    required CardListCoordinator<ShopCardCoordinator> inventoryCoordinators,
    required PlayerCoordinator playerCoordinator,
  }) : _inventoryCoordinators = inventoryCoordinators,
       _displayCoordinators = displayCoordinators,
       _playerCoordinator = playerCoordinator {
    _inventoryCoordinators.shuffle();
    _addCardsToDisplayFromInventory(6); //TODO not hardcoded
  }

  final CardListCoordinator<ShopCardCoordinator> _displayCoordinators;
  final CardListCoordinator<ShopCardCoordinator> _inventoryCoordinators;
  final PlayerCoordinator _playerCoordinator;

  CardListCoordinator<ShopCardCoordinator> get displayCoordinator =>
      _displayCoordinators;

  PlayerCoordinator get playerCoordinator => _playerCoordinator;

  void _onCardPlayed(CardCoordinator cardCoordinator) {
    cardCoordinator.onCardPlayed = null;
    final shopCardCoordinator = cardCoordinator as ShopCardCoordinator;
    _displayCoordinators.removeCard(shopCardCoordinator);
    _playerCoordinator.playerInfoCoordinator.adjustCredits(
      -shopCardCoordinator.cost,
    );
    _playerCoordinator.discardCardsCoordinator.addCard(shopCardCoordinator);
    _playerCoordinator.playerInfoCoordinator.adjustCredits(-shopCardCoordinator.cost);
  }

  void refillShop() {
    final numberOfCardsNeeded =
        6 - _displayCoordinators.cardCoordinators.length; //TODO not hardcoded
    if (numberOfCardsNeeded > 0) {
      _addCardsToDisplayFromInventory(numberOfCardsNeeded);
    }
  }

  void _addCardsToDisplayFromInventory(int numberOfCards) {
    final drawnCards = _inventoryCoordinators.drawCards(numberOfCards);
    for (final card in drawnCards) {
      card.onCardPlayed = _onCardPlayed;
    }

    _displayCoordinators.addCards(drawnCards);
  }

  //Call if ever exit the game
  void dispose() {
    for (final card in _displayCoordinators.cardCoordinators) {
      card.onCardPlayed = null;
    }
  }
}
