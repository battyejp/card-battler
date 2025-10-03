import 'package:card_battler/game/factories/player_coordinator_factory.dart';
import 'package:card_battler/game/factories/team_coordinator_factory.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/services/card/effects/effect_processor.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';

class PlayerCoordinatorsResult {

  PlayerCoordinatorsResult({
    required this.playerCoordinators,
    required this.teamCoordinator,
    required this.effectProcessor,
  });
  final List playerCoordinators;
  final dynamic teamCoordinator;
  final EffectProcessor effectProcessor;
}

class PlayerCoordinatorsBuilder {
  static PlayerCoordinatorsResult build({
    required GameStateModel state,
    required GamePhaseManager gamePhaseManager,
    required ActivePlayerManager activePlayerManager,
  }) {
    final effectProcessor = EffectProcessor();
    final playerCoordinators =
        PlayerCoordinatorFactory.createPlayerCoordinators(
          players: state.players,
          gamePhaseManager: gamePhaseManager,
          activePlayerManager: activePlayerManager,
          effectProcessor: effectProcessor,
        );
    final teamCoordinator = TeamCoordinatorFactory.createTeamCoordinator(
      playerCoordinators: playerCoordinators,
      state: state,
    );
    effectProcessor.teamCoordinator = teamCoordinator;
    activePlayerManager.players = playerCoordinators;
    activePlayerManager.setNextPlayerToActive();
    return PlayerCoordinatorsResult(
      playerCoordinators: playerCoordinators,
      teamCoordinator: teamCoordinator,
      effectProcessor: effectProcessor,
    );
  }
}
