import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/enemy/enemies_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/enemy_turn_scene_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/game_scene_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shared/turn_button_component_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/base_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/bases_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/players_info_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/team_coordinator.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/services/card/effects/effect_processor.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';
import 'package:card_battler/game/services/ui/dialog_service.dart';

class PlayerTurnSceneCoordinatorFactory {
  static ShopCoordinator createShopCoordinator({
    required GameStateModel state,
    required GamePhaseManager gamePhaseManager,
    required ActivePlayerManager activePlayerManager,
  }) => ShopCoordinator(
    displayCoordinators: CardListCoordinator<ShopCardCoordinator>(
      cardCoordinators: [],
    ),
    inventoryCoordinators: CardListCoordinator<ShopCardCoordinator>(
      cardCoordinators: state.shop.inventoryCards.allCards
          .map(
            (card) => ShopCardCoordinator(
              card,
              gamePhaseManager,
              activePlayerManager,
            ),
          )
          .toList(),
    ),
  );

  static TeamCoordinator createTeamCoordinator({
    required PlayersInfoCoordinator playersInfoCoordinator,
    required GameStateModel state,
  }) => TeamCoordinator(
    playersInfoCoordinator: playersInfoCoordinator,
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
    activePlayerManager: activePlayerManager
  );

  static GameSceneCoordinator createPlayerTurnSceneCoordinator({
    required List<PlayerCoordinator> playerCoordinators,
    required GameStateModel state,
    required PlayersInfoCoordinator playersInfoCoordinator,
    required EnemiesCoordinator enemiesCoordinator,
    required GamePhaseManager gamePhaseManager,
    required EffectProcessor effectProcessor,
    required ActivePlayerManager activePlayerManager,
    required EnemyTurnSceneCoordinator enemyTurnSceneCoordinator,
    required DialogService dialogService,
  }) => GameSceneCoordinator(
    playerCoordinator: playerCoordinators.firstWhere(
      (pc) => pc.playerInfoCoordinator.isActive,
    ),
    shopCoordinator: createShopCoordinator(
      state: state,
      gamePhaseManager: gamePhaseManager,
      activePlayerManager: activePlayerManager,
    ),
    teamCoordinator: createTeamCoordinator(
      playersInfoCoordinator: playersInfoCoordinator,
      state: state,
    ),
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
