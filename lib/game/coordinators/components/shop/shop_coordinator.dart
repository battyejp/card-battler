import 'package:card_battler/game/coordinators/components/shop/shop_display_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_inventory_coordinator.dart';

class ShopCoordinator {
  //TODO should theses just be lists like in player
  final ShopDisplayCoordinator _displayCoordinator;
  final ShopInventoryCoordinator _inventoryCoordinator;

  ShopCoordinator({
    required ShopDisplayCoordinator displayCoordinator,
    required ShopInventoryCoordinator inventoryCoordinator,
  }) : _inventoryCoordinator = inventoryCoordinator,
       _displayCoordinator = displayCoordinator;

  ShopDisplayCoordinator get displayCoordinator => _displayCoordinator;
  ShopInventoryCoordinator get inventoryCoordinator => _inventoryCoordinator;
}
