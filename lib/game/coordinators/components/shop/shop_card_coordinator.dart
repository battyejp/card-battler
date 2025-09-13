import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/services/card/cards_selection_manager_service.dart';
import 'package:card_battler/game/services/game_state/game_phase_manager.dart';

class ShopCardCoordinator extends CardCoordinator {
  final ShopCardModel _cardModel;
  final CardsSelectionManagerService _cardsSelectionManagerService;
  final GamePhaseManager _gamePhaseManager;

  ShopCardCoordinator(
    this._cardModel,
    this._cardsSelectionManagerService,
    this._gamePhaseManager,
  ) : super(
        cardModel: _cardModel,
        cardsSelectionManagerService: _cardsSelectionManagerService,
        gamePhaseManager: _gamePhaseManager,
      );

  int get cost => _cardModel.cost;
}
