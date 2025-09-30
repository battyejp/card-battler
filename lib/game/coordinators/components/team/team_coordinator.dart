import 'package:card_battler/game/coordinators/components/team/bases_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/team_mate_coordinator.dart';

class TeamCoordinator {
  TeamCoordinator({
    required List<TeamMateCoordinator> teamMatesCoordinators,
    required BasesCoordinator basesCoordinator,
  }) : _teamMatesCoordinators = teamMatesCoordinators,
       _basesCoordinator = basesCoordinator;

  final BasesCoordinator _basesCoordinator;
  final List<TeamMateCoordinator> _teamMatesCoordinators;

  List<TeamMateCoordinator> get teamMatesCoordinators => _teamMatesCoordinators;
  BasesCoordinator get basesCoordinator => _basesCoordinator;

  List<TeamMateCoordinator> get activePlayers =>
      _teamMatesCoordinators.where((tm) => tm.playerInfoCoordinator.isActive).toList();

  List<TeamMateCoordinator> get inactivePlayers =>
      _teamMatesCoordinators.where((tm) => !tm.playerInfoCoordinator.isActive).toList();
}
