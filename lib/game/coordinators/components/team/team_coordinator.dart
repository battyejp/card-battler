import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/bases_coordinator.dart';

class TeamCoordinator {
  TeamCoordinator({
    required List<PlayerCoordinator> teamMatesCoordinators,
    required BasesCoordinator basesCoordinator,
  }) : _teamMatesCoordinators = teamMatesCoordinators,
       _basesCoordinator = basesCoordinator;

  final BasesCoordinator _basesCoordinator;
  final List<PlayerCoordinator> _teamMatesCoordinators;

  List<PlayerCoordinator> get teamMatesCoordinators => _teamMatesCoordinators;
  BasesCoordinator get basesCoordinator => _basesCoordinator;

  PlayerCoordinator get activePlayer =>
      _teamMatesCoordinators.firstWhere((tm) => tm.isActive);

  List<PlayerCoordinator> get inactivePlayers =>
      _teamMatesCoordinators.where((tm) => !tm.isActive).toList();
}
