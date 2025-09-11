import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';

class ShopCardCoordinator extends CardCoordinator {
  final ShopCardModel cardModel;

  ShopCardCoordinator(this.cardModel) : super(cardModel);

  int get cost => cardModel.cost;
}
