import 'package:card_battler/game/coordinators/components/shop/shop_card_coordinator.dart';

class ShopInventoryCoordinator {
  final List<ShopCardCoordinator> _shopCardCoordinators;

  ShopInventoryCoordinator(this._shopCardCoordinators);

  List<ShopCardCoordinator> get shopCardCoordinators => _shopCardCoordinators;
}
