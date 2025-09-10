import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';

class PlayerTurnSceneCoordinator {
  final PlayerCoordinator _playerCoordinator;

  PlayerTurnSceneCoordinator({required PlayerCoordinator coordinator})
      : _playerCoordinator = coordinator;

  PlayerCoordinator get playerCoordinator => _playerCoordinator;
}