import 'package:card_battler/game/factories/enemy_coordinator_factory.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/services/card/effects/effect_processor.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';

class EnemyCoordinatorsResult {
  EnemyCoordinatorsResult({
    required this.enemyCoordinators,
    required this.enemiesCoordinator,
    required this.enemyTurnSceneCoordinator,
  });
  final List enemyCoordinators;
  final dynamic enemiesCoordinator;
  final dynamic enemyTurnSceneCoordinator;
}

class EnemyCoordinatorsBuilder {
  static EnemyCoordinatorsResult build({
    required GameStateModel state,
    required GamePhaseManager gamePhaseManager,
    required ActivePlayerManager activePlayerManager,
    required EffectProcessor effectProcessor,
  }) {
    final enemyCoordinators = EnemyCoordinatorFactory.createEnemyCoordinators(
      enemiesModel: state.enemiesModel,
    );
    final enemyTurnSceneCoordinator =
        EnemyCoordinatorFactory.createEnemyTurnSceneCoordinator(
          enemiesModel: state.enemiesModel,
          effectProcessor: effectProcessor,
          gamePhaseManager: gamePhaseManager,
          activePlayerManager: activePlayerManager,
        );
    final enemiesCoordinator = EnemyCoordinatorFactory.createEnemiesCoordinator(
      enemyCoordinators: enemyCoordinators,
      enemiesModel: state.enemiesModel,
      gamePhaseManager: gamePhaseManager,
      activePlayerManager: activePlayerManager,
    );
    return EnemyCoordinatorsResult(
      enemyCoordinators: enemyCoordinators,
      enemiesCoordinator: enemiesCoordinator,
      enemyTurnSceneCoordinator: enemyTurnSceneCoordinator,
    );
  }
}
