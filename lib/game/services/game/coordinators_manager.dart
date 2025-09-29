import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/enemy_turn_scene_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/game_scene_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/players_info_coordinator.dart';
import 'package:card_battler/game/factories/enemy_coordinator_factory.dart';
import 'package:card_battler/game/factories/player_coordinator_factory.dart';
import 'package:card_battler/game/factories/player_turn_scene_coordinator_factory.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/services/card/effects/effect_processor.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';
import 'package:card_battler/game/services/ui/dialog_service.dart';

class CoordinatorsManager {
  CoordinatorsManager(
    GamePhaseManager gamePhaseManager,
    GameStateModel state,
    ActivePlayerManager activePlayerManager,
    DialogService dialogService,
  ) {
    final effectProcessor = EffectProcessor();

    _playerCoordinators = PlayerCoordinatorFactory.createPlayerCoordinators(
      players: state.players,
      gamePhaseManager: gamePhaseManager,
      activePlayerManager: activePlayerManager,
      effectProcessor: effectProcessor,
    );

    _playersInfoCoordinator =
        PlayerCoordinatorFactory.createPlayersInfoCoordinator(
          playerCoordinators: _playerCoordinators,
        );

    effectProcessor.playersInfoCoordinator = _playersInfoCoordinator;
    activePlayerManager.players = _playerCoordinators;
    activePlayerManager.setNextPlayerToActive();

    final enemyCoordinators = EnemyCoordinatorFactory.createEnemyCoordinators(
      enemiesModel: state.enemiesModel,
    );

    _enemyTurnSceneCoordinator =
        EnemyCoordinatorFactory.createEnemyTurnSceneCoordinator(
          enemiesModel: state.enemiesModel,
          effectProcessor: effectProcessor,
          gamePhaseManager: gamePhaseManager,
          activePlayerManager: activePlayerManager,
        );

    _playerTurnSceneCoordinator =
        PlayerTurnSceneCoordinatorFactory.createPlayerTurnSceneCoordinator(
          playerCoordinators: _playerCoordinators,
          state: state,
          playersInfoCoordinator: _playersInfoCoordinator,
          dialogService: dialogService,
          enemiesCoordinator: EnemyCoordinatorFactory.createEnemiesCoordinator(
            enemyCoordinators: enemyCoordinators,
            enemiesModel: state.enemiesModel,

            gamePhaseManager: gamePhaseManager,
            activePlayerManager: activePlayerManager,
          ),
          gamePhaseManager: gamePhaseManager,
          effectProcessor: effectProcessor,
          activePlayerManager: activePlayerManager,
          enemyTurnSceneCoordinator: _enemyTurnSceneCoordinator,
        );
  }

  late GameSceneCoordinator _playerTurnSceneCoordinator;
  late EnemyTurnSceneCoordinator _enemyTurnSceneCoordinator;
  late PlayersInfoCoordinator _playersInfoCoordinator;
  late List<PlayerCoordinator> _playerCoordinators;

  GameSceneCoordinator get playerTurnSceneCoordinator =>
      _playerTurnSceneCoordinator;
  EnemyTurnSceneCoordinator get enemyTurnSceneCoordinator =>
      _enemyTurnSceneCoordinator;
}
