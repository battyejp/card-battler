import 'package:card_battler/game/coordinators/components/team/team_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/team_mate_coordinator.dart';
import 'package:card_battler/game/models/shared/effect_model.dart';

class EffectTargetResolver {
  EffectTargetResolver(TeamCoordinator teamCoordinator) : _teamCoordinator = teamCoordinator;

  final TeamCoordinator _teamCoordinator;

  List<TeamMateCoordinator> resolveTargets(EffectModel effect) {
    switch (effect.target) {
      case EffectTarget.activePlayer:
        return [_teamCoordinator.activePlayer];
      case EffectTarget.allPlayers:
        return _teamCoordinator.teamMatesCoordinators;
      case EffectTarget.nonActivePlayers:
        return _teamCoordinator.inactivePlayers;
      default:
        return [];
    }
  }
}