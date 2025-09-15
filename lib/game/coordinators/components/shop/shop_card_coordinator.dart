import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/services/card/cards_selection_manager_service.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';

class ShopCardCoordinator extends CardCoordinator {
  final ShopCardModel _cardModel;

  ShopCardCoordinator(
    this._cardModel,
    CardsSelectionManagerService cardsSelectionManagerService,
    GamePhaseManager gamePhaseManager,
    ActivePlayerManager activePlayerManager,
  ) : super(
        cardModel: _cardModel,
        cardsSelectionManagerService: cardsSelectionManagerService,
        gamePhaseManager: gamePhaseManager,
        activePlayerManager: activePlayerManager,
      );

  int get cost => _cardModel.cost;

  @override
  bool isActionDisabled(PlayerInfoCoordinator playerInfoCoordinator) {
    return playerInfoCoordinator.credits < cost;
  }
}
