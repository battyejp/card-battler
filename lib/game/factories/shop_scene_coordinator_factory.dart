import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/shop_scene_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_display_coordinator.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';

class ShopSceneCoordinatorFactory {
  static ShopSceneCoordinator createShopCoordinator({
    required GameStateModel state,
    required GamePhaseManager gamePhaseManager,
    required ActivePlayerManager activePlayerManager,
  }) => ShopSceneCoordinator(
    shopDisplayCoordinator: ShopDisplayCoordinator(
      cardCoordinators: CardListCoordinator<ShopCardCoordinator>(
        cardCoordinators: [],
      ),
    ),
    inventoryCoordinators: CardListCoordinator<ShopCardCoordinator>(
      cardCoordinators: state.shop.inventoryCards.allCards
          .map(
            (card) => ShopCardCoordinator(
              card,
              gamePhaseManager,
              activePlayerManager,
            ),
          )
          .toList(),
    ),
    playerCoordinator: activePlayerManager.activePlayer!,
  );
}
