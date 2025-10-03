import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';

class ShopCardCoordinator extends CardCoordinator {
  ShopCardCoordinator(
    this._cardModel,
    GamePhaseManager gamePhaseManager,
    ActivePlayerManager activePlayerManager,
  ) : super(
        cardModel: _cardModel,
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
