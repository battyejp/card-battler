import 'package:card_battler/game/coordinators/components/enemy/enemy_turn_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/game_scene_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/shop_scene_coordinator.dart';
import 'package:card_battler/game/factories/enemy_coordinator_factory.dart';
import 'package:card_battler/game/factories/game_scene_coordinator_factory.dart';
import 'package:card_battler/game/factories/player_coordinator_factory.dart';
import 'package:card_battler/game/factories/shop_scene_coordinator_factory.dart';
import 'package:card_battler/game/factories/team_coordinator_factory.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/services/card/effects/effect_processor.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';
import 'package:card_battler/game/services/ui/dialog_service.dart';

/// Manages the lifecycle and coordination of all game coordinators.
/// 
/// This class orchestrates the creation of various coordinator components
/// using specialized factories and maintains references to the primary
/// scene coordinators used throughout the game.
class CoordinatorsManager {
  CoordinatorsManager(
    GamePhaseManager gamePhaseManager,
    GameStateModel state,
    ActivePlayerManager activePlayerManager,
    DialogService dialogService,
  ) {
    // Create effect processor (will be configured after team coordinator is created)
    final effectProcessor = EffectProcessor();

    // Create player coordinators
    final playerCoordinators = PlayerCoordinatorFactory.createPlayerCoordinators(
      players: state.players,
      gamePhaseManager: gamePhaseManager,
      activePlayerManager: activePlayerManager,
      effectProcessor: effectProcessor,
    );

    // Create team coordinator from player coordinators
    final teamCoordinator = TeamCoordinatorFactory.createTeamCoordinator(
      playerCoordinators: playerCoordinators,
      state: state,
    );

    // Configure effect processor with team coordinator
    effectProcessor.teamCoordinator = teamCoordinator;

    // Configure active player manager
    activePlayerManager.players = playerCoordinators;
    activePlayerManager.setNextPlayerToActive();

    // Create enemy coordinators
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

    // Create enemies coordinator for the game scene
    final enemiesCoordinator = EnemyCoordinatorFactory.createEnemiesCoordinator(
      enemyCoordinators: enemyCoordinators,
      enemiesModel: state.enemiesModel,
      gamePhaseManager: gamePhaseManager,
      activePlayerManager: activePlayerManager,
    );

    // Create shop scene coordinator
    _shopSceneCoordinator = ShopSceneCoordinatorFactory.createShopCoordinator(
      state: state,
      gamePhaseManager: gamePhaseManager,
      activePlayerManager: activePlayerManager,
      teamCoordinator: teamCoordinator,
    );

    // Create main game scene coordinator
    _gameSceneCoordinator = GameSceneCoordinatorFactory.createGameSceneCoordinator(
      playerCoordinators: playerCoordinators,
      enemiesCoordinator: enemiesCoordinator,
      gamePhaseManager: gamePhaseManager,
      effectProcessor: effectProcessor,
      activePlayerManager: activePlayerManager,
      enemyTurnSceneCoordinator: _enemyTurnSceneCoordinator,
      dialogService: dialogService,
      shopCoordinator: _shopSceneCoordinator,
      teamCoordinator: teamCoordinator,
    );
  }

  late GameSceneCoordinator _gameSceneCoordinator;
  late EnemyTurnCoordinator _enemyTurnSceneCoordinator;
  late ShopSceneCoordinator _shopSceneCoordinator;

  GameSceneCoordinator get gameSceneCoordinator => _gameSceneCoordinator;
  EnemyTurnCoordinator get enemyTurnSceneCoordinator =>
      _enemyTurnSceneCoordinator;
  ShopSceneCoordinator get shopSceneCoordinator => _shopSceneCoordinator;
}
