import 'package:card_battler/game/coordinators/components/shop/shop_card_coordinator.dart';

class ShopInventoryCoordinator {
  ShopInventoryCoordinator(this._shopCardCoordinators);

  final List<ShopCardCoordinator> _shopCardCoordinators;
  List<ShopCardCoordinator> get shopCardCoordinators => _shopCardCoordinators;
}
