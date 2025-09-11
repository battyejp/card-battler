import 'package:card_battler/game/coordinators/components/shop/shop_card_coordinator.dart';

class ShopDisplayCoordinator {
  final List<ShopCardCoordinator> _shopCardCoordinators;
  final int _itemsPerRow;
  final int _numberOfRows;

  ShopDisplayCoordinator({
    required List<ShopCardCoordinator> shopCardCoordinators,
    int itemsPerRow = 3,
    int numberOfRows = 2,
  }) : _shopCardCoordinators = shopCardCoordinators,
       _itemsPerRow = itemsPerRow,
       _numberOfRows = numberOfRows;

  List<ShopCardCoordinator> get shopCardCoordinators => _shopCardCoordinators;
  int get itemsPerRow => _itemsPerRow;
  int get numberOfRows => _numberOfRows;
}
