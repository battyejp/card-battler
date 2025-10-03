import 'package:card_battler/game/coordinators/builders/enemy_coordinators_builder.dart';
import 'package:card_battler/game/coordinators/builders/player_coordinators_builder.dart';
import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/factories/game_scene_coordinator_factory.dart';
import 'package:card_battler/game/factories/shop_scene_coordinator_factory.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';
import 'package:card_battler/game/services/ui/dialog_service.dart';

class SceneCoordinatorsResult {
  SceneCoordinatorsResult({
    required this.gameSceneCoordinator,
    required this.enemyTurnSceneCoordinator,
    required this.shopSceneCoordinator,
  });
  final dynamic gameSceneCoordinator;
  final dynamic enemyTurnSceneCoordinator;
  final dynamic shopSceneCoordinator;
}

class SceneCoordinatorsBuilder {
  static SceneCoordinatorsResult build({
    required PlayerCoordinatorsResult playerResult,
    required EnemyCoordinatorsResult enemyResult,
    required GameStateModel state,
    required GamePhaseManager gamePhaseManager,
    required ActivePlayerManager activePlayerManager,
    required DialogService dialogService,
  }) {
    final shopSceneCoordinator =
        ShopSceneCoordinatorFactory.createShopCoordinator(
          state: state,
          gamePhaseManager: gamePhaseManager,
          activePlayerManager: activePlayerManager,
          teamCoordinator: playerResult.teamCoordinator,
        );
    final gameSceneCoordinator =
        GameSceneCoordinatorFactory.createGameSceneCoordinator(
          playerCoordinators: List<PlayerCoordinator>.from(
            playerResult.playerCoordinators,
          ),
          enemiesCoordinator: enemyResult.enemiesCoordinator,
          gamePhaseManager: gamePhaseManager,
          effectProcessor: playerResult.effectProcessor,
          activePlayerManager: activePlayerManager,
          enemyTurnSceneCoordinator: enemyResult.enemyTurnSceneCoordinator,
          dialogService: dialogService,
          shopCoordinator: shopSceneCoordinator,
          teamCoordinator: playerResult.teamCoordinator,
        );
    return SceneCoordinatorsResult(
      gameSceneCoordinator: gameSceneCoordinator,
      enemyTurnSceneCoordinator: enemyResult.enemyTurnSceneCoordinator,
      shopSceneCoordinator: shopSceneCoordinator,
    );
  }
}
