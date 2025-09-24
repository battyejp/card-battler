import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/services/card/cards_selection_manager_service.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';

class ShopCardCoordinator extends CardCoordinator {
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

  final ShopCardModel _cardModel;

  int get cost => _cardModel.cost;
  int get creditsAvailable =>
      activePlayerManager.activePlayer!.playerInfoCoordinator.credits;

  bool isActionDisabled() =>
      activePlayerManager.activePlayer!.playerInfoCoordinator.credits < cost;
}
