import 'package:card_battler/game/coordinators/components/enemy/enemies_coordinator.dart';
import 'package:card_battler/game/coordinators/components/enemy/enemy_turn_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/game_scene_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/shop_scene_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shared/turn_button_component_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/base_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/bases_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/team_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/team_mate_coordinator.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/services/card/effects/effect_processor.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';
import 'package:card_battler/game/services/ui/dialog_service.dart';

class PlayerTurnSceneCoordinatorFactory {
  static TeamCoordinator createTeamCoordinator({
    required List<TeamMateCoordinator> teamMatesCoordinators,
    required GameStateModel state,
  }) => TeamCoordinator(
    teamMatesCoordinators: teamMatesCoordinators,
    basesCoordinator: BasesCoordinator(
      baseCoordinators: state.bases
          .map((base) => BaseCoordinator(model: base))
          .toList(),
    ),
  );

  static TurnButtonComponentCoordinator createTurnButtonComponentCoordinator({
    required GamePhaseManager gamePhaseManager,
    required ActivePlayerManager activePlayerManager,
    required DialogService dialogService,
  }) => TurnButtonComponentCoordinator(
    gamePhaseManager: gamePhaseManager,
    dialogService: dialogService,
    activePlayerManager: activePlayerManager,
  );

  static GameSceneCoordinator createPlayerTurnSceneCoordinator({
    required List<PlayerCoordinator> playerCoordinators,
    required GameStateModel state,
    required EnemiesCoordinator enemiesCoordinator,
    required GamePhaseManager gamePhaseManager,
    required EffectProcessor effectProcessor,
    required ActivePlayerManager activePlayerManager,
    required EnemyTurnCoordinator enemyTurnSceneCoordinator,
    required DialogService dialogService,
    required ShopSceneCoordinator shopCoordinator,
    required TeamCoordinator teamCoordinator,
  }) => GameSceneCoordinator(
    playerCoordinator: playerCoordinators.firstWhere(
      (pc) => pc.playerInfoCoordinator.isActive,
    ),
    shopCoordinator: shopCoordinator,
    teamCoordinator: teamCoordinator,
    // teamCoordinator: createTeamCoordinator(
    //   teamMatesCoordinators: playerCoordinators
    //       .map((pc) => TeamMateCoordinator(pc.playerInfoCoordinator, pc.handCardsCoordinator))
    //       .toList(),
    //   state: state,
    // ),
    enemiesCoordinator: enemiesCoordinator,
    gamePhaseManager: gamePhaseManager,
    effectProcessor: effectProcessor,
    activePlayerManager: activePlayerManager,
    enemyTurnSceneCoordinator: enemyTurnSceneCoordinator,
    turnButtonComponentCoordinator: createTurnButtonComponentCoordinator(
      gamePhaseManager: gamePhaseManager,
      activePlayerManager: activePlayerManager,
      dialogService: dialogService,
    ),
  );
}
