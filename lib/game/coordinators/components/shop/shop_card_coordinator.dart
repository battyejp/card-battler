import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/services/card/cards_selection_manager_service.dart';

class ShopCardCoordinator extends CardCoordinator {
  final ShopCardModel cardModel;
  final CardsSelectionManagerService cardsSelectionManagerService;

  ShopCardCoordinator(this.cardModel, this.cardsSelectionManagerService)
    : super(cardModel, cardsSelectionManagerService);

  int get cost => cardModel.cost;
}
