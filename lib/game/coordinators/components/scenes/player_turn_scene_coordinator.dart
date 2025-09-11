import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_coordinator.dart';

class PlayerTurnSceneCoordinator {
  final PlayerCoordinator _playerCoordinator;
  final ShopCoordinator _shopCoordinator;

  PlayerTurnSceneCoordinator({
    required PlayerCoordinator playerCoordinator,
    required ShopCoordinator shopCoordinator,
  }) : _playerCoordinator = playerCoordinator,
       _shopCoordinator = shopCoordinator;

  PlayerCoordinator get playerCoordinator => _playerCoordinator;
  ShopCoordinator get shopCoordinator => _shopCoordinator;
}
