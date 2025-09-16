import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_card_coordinator.dart';

class ShopDisplayCoordinator {
  ShopDisplayCoordinator({
    required CardListCoordinator<ShopCardCoordinator> cardCoordinators,
  }) : _cardCoordinators = cardCoordinators,
       _itemsPerRow = 3,
       _numberOfRows = 2;

  final CardListCoordinator<ShopCardCoordinator> _cardCoordinators;
  final int _itemsPerRow;
  final int _numberOfRows;

  CardListCoordinator<ShopCardCoordinator> get cardCoordinators =>
      _cardCoordinators;

  int get itemsPerRow => _itemsPerRow;
  int get numberOfRows => _numberOfRows;
}
