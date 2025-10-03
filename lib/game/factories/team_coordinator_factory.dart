import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/base_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/bases_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/team_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/team_mate_coordinator.dart';
import 'package:card_battler/game/models/game_state_model.dart';

class TeamCoordinatorFactory {
  static TeamCoordinator createTeamCoordinator({
    required List<PlayerCoordinator> playerCoordinators,
    required GameStateModel state,
  }) => TeamCoordinator(
    teamMatesCoordinators: playerCoordinators
        .map(
          (pc) => TeamMateCoordinator(
            pc.playerInfoCoordinator,
            pc.handCardsCoordinator,
          ),
        )
        .toList(),
    basesCoordinator: BasesCoordinator(
      baseCoordinators: state.bases
          .map((base) => BaseCoordinator(model: base))
          .toList(),
    ),
  );
}
