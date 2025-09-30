import 'package:card_battler/game/coordinators/components/enemy/enemy_turn_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/game_scene_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/shop_scene_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/team_mate_coordinator.dart';
import 'package:card_battler/game/factories/enemy_coordinator_factory.dart';
import 'package:card_battler/game/factories/player_coordinator_factory.dart';
import 'package:card_battler/game/factories/player_turn_scene_coordinator_factory.dart';
import 'package:card_battler/game/factories/shop_scene_coordinator_factory.dart';
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

    final teamCoordinator =
        PlayerTurnSceneCoordinatorFactory.createTeamCoordinator(
          teamMatesCoordinators: _playerCoordinators
              .map(
                (pc) => TeamMateCoordinator(
                  pc.playerInfoCoordinator,
                  pc.handCardsCoordinator,
                ),
              )
              .toList(),
          state: state,
        );

    effectProcessor.teamCoordinator = teamCoordinator;

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

    _shopSceneCoordinator = ShopSceneCoordinatorFactory.createShopCoordinator(
      state: state,
      gamePhaseManager: gamePhaseManager,
      activePlayerManager: activePlayerManager,
      teamCoordinator: teamCoordinator,
    );

    _gameSceneCoordinator =
        PlayerTurnSceneCoordinatorFactory.createPlayerTurnSceneCoordinator(
          playerCoordinators: _playerCoordinators,
          state: state,
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
          shopCoordinator: _shopSceneCoordinator,
          teamCoordinator: teamCoordinator,
        );
  }

  late GameSceneCoordinator _gameSceneCoordinator;
  late EnemyTurnCoordinator _enemyTurnSceneCoordinator;
  late ShopSceneCoordinator _shopSceneCoordinator;
  late List<PlayerCoordinator> _playerCoordinators;

  GameSceneCoordinator get gameSceneCoordinator => _gameSceneCoordinator;
  EnemyTurnCoordinator get enemyTurnSceneCoordinator =>
      _enemyTurnSceneCoordinator;
  ShopSceneCoordinator get shopSceneCoordinator => _shopSceneCoordinator;
}
