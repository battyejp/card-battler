import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/team_coordinator.dart';

class PlayerTurnSceneCoordinator {
  final PlayerCoordinator _playerCoordinator;
  final ShopCoordinator _shopCoordinator;
  final TeamCoordinator _teamCoordinator;

  PlayerTurnSceneCoordinator({
    required PlayerCoordinator playerCoordinator,
    required ShopCoordinator shopCoordinator,
    required TeamCoordinator teamCoordinator,
  }) : _playerCoordinator = playerCoordinator,
       _shopCoordinator = shopCoordinator,
       _teamCoordinator = teamCoordinator;

  PlayerCoordinator get playerCoordinator => _playerCoordinator;
  ShopCoordinator get shopCoordinator => _shopCoordinator;
  TeamCoordinator get teamCoordinator => _teamCoordinator;
}
