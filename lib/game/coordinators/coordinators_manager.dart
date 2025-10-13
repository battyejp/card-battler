import 'package:card_battler/game/coordinators/builders/enemy_coordinators_builder.dart';
import 'package:card_battler/game/coordinators/builders/player_coordinators_builder.dart';
import 'package:card_battler/game/coordinators/builders/scene_coordinators_builder.dart';
import 'package:card_battler/game/coordinators/components/enemy/enemy_turn_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/game_scene_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/shop_scene_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shared/turn_button_component_coordinator.dart';
import 'package:card_battler/game/models/game_state_model.dart';
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
    TurnButtonComponentCoordinator turnButtonComponentCoordinator,
  ) {
    final playerResult = PlayerCoordinatorsBuilder.build(
      state: state,
      gamePhaseManager: gamePhaseManager,
      activePlayerManager: activePlayerManager,
      turnButtonComponentCoordinator: turnButtonComponentCoordinator,
    );

    final enemyResult = EnemyCoordinatorsBuilder.build(
      state: state,
      gamePhaseManager: gamePhaseManager,
      activePlayerManager: activePlayerManager,
      effectProcessor: playerResult.effectProcessor,
    );

    final sceneResult = SceneCoordinatorsBuilder.build(
      playerResult: playerResult,
      enemyResult: enemyResult,
      state: state,
      gamePhaseManager: gamePhaseManager,
      activePlayerManager: activePlayerManager,
      dialogService: dialogService,
    );

    _gameSceneCoordinator = sceneResult.gameSceneCoordinator;
    _enemyTurnSceneCoordinator = sceneResult.enemyTurnSceneCoordinator;
    _shopSceneCoordinator = sceneResult.shopSceneCoordinator;
  }

  late GameSceneCoordinator _gameSceneCoordinator;
  late EnemyTurnCoordinator _enemyTurnSceneCoordinator;
  late ShopSceneCoordinator _shopSceneCoordinator;

  GameSceneCoordinator get gameSceneCoordinator => _gameSceneCoordinator;
  EnemyTurnCoordinator get enemyTurnSceneCoordinator =>
      _enemyTurnSceneCoordinator;
  ShopSceneCoordinator get shopSceneCoordinator => _shopSceneCoordinator;
}
