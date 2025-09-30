import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_display_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/team_coordinator.dart';

class ShopSceneCoordinator {
  ShopSceneCoordinator({
    required ShopDisplayCoordinator shopDisplayCoordinator,
    required CardListCoordinator<ShopCardCoordinator> inventoryCoordinators,
    required TeamCoordinator teamCoordinator,
  }) : _inventoryCoordinators = inventoryCoordinators,
       _shopDisplayCoordinator = shopDisplayCoordinator,
       _teamCoordinator = teamCoordinator {
    _inventoryCoordinators.shuffle();
    refillShop();
  }

  final ShopDisplayCoordinator _shopDisplayCoordinator;
  final CardListCoordinator<ShopCardCoordinator> _inventoryCoordinators;
  final TeamCoordinator _teamCoordinator;

  Function(ShopCardCoordinator)? onCardBought;

  ShopDisplayCoordinator get shopDisplayCoordinator =>
      _shopDisplayCoordinator;

  TeamCoordinator get teamCoordinator => _teamCoordinator;

  void _onCardBought(ShopCardCoordinator cardCoordinator) {
    final playerCoordinator = _teamCoordinator.activePlayer;
    _teamCoordinator.activePlayer.playerInfoCoordinator.adjustCredits(
      -cardCoordinator.cost,
    );

    onCardBought?.call(cardCoordinator);
    playerCoordinator.playerInfoCoordinator.adjustCredits(
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
