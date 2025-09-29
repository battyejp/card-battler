import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_display_coordinator.dart';

class ShopSceneCoordinator {
  ShopSceneCoordinator({
    required ShopDisplayCoordinator shopDisplayCoordinator,
    required CardListCoordinator<ShopCardCoordinator> inventoryCoordinators,
    required PlayerCoordinator playerCoordinator,
  }) : _inventoryCoordinators = inventoryCoordinators,
       _shopDisplayCoordinator = shopDisplayCoordinator,
       _playerCoordinator = playerCoordinator {
    _inventoryCoordinators.shuffle();
    refillShop();
  }

  final ShopDisplayCoordinator _shopDisplayCoordinator;
  final CardListCoordinator<ShopCardCoordinator> _inventoryCoordinators;
  final PlayerCoordinator _playerCoordinator;

  ShopDisplayCoordinator get shopDisplayCoordinator =>
      _shopDisplayCoordinator;

  PlayerCoordinator get playerCoordinator => _playerCoordinator;

  void _onCardBought(ShopCardCoordinator cardCoordinator) {
    _playerCoordinator.playerInfoCoordinator.adjustCredits(
      -cardCoordinator.cost,
    );
    _playerCoordinator.discardCardsCoordinator.addCard(cardCoordinator);
    _playerCoordinator.playerInfoCoordinator.adjustCredits(
      -cardCoordinator.cost,
    );
  }

  void refillShop() {
    if (_shopDisplayCoordinator.missingCards > 0) {
      final drawnCards = _inventoryCoordinators.drawCards(_shopDisplayCoordinator.missingCards);
      _shopDisplayCoordinator.addCards(drawnCards);
      _shopDisplayCoordinator.onCardBought = _onCardBought;
    }
  }

  void dispose() {
    _shopDisplayCoordinator.onCardBought = null;
    _shopDisplayCoordinator.dispose();
  }
}
