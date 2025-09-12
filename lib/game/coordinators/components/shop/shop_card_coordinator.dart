import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/services/card/cards_selection_manager_service.dart';
import 'package:card_battler/game/services/game_state/game_phase_manager.dart';

class ShopCardCoordinator extends CardCoordinator {
  final ShopCardModel cardModel;
  final CardsSelectionManagerService cardsSelectionManagerService;
  final GamePhaseManager gamePhaseManager;

  ShopCardCoordinator(
    this.cardModel,
    this.cardsSelectionManagerService,
    this.gamePhaseManager,
  ) : super(cardModel, cardsSelectionManagerService, gamePhaseManager);

  int get cost => cardModel.cost;
}
