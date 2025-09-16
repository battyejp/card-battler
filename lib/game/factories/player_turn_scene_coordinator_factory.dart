import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/enemy/enemies_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/player_turn_scene_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/base_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/bases_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/players_info_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/team_coordinator.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/services/card/cards_selection_manager_service.dart';
import 'package:card_battler/game/services/card/effect_processor.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';

class PlayerTurnSceneCoordinatorFactory {
  static ShopCoordinator createShopCoordinator({
    required GameStateModel state,
    required CardsSelectionManagerService cardsSelectionManagerService,
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
                cardsSelectionManagerService,
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

  static PlayerTurnSceneCoordinator createPlayerTurnSceneCoordinator({
    required List<PlayerCoordinator> playerCoordinators,
    required GameStateModel state,
    required PlayersInfoCoordinator playersInfoCoordinator,
    required EnemiesCoordinator enemiesCoordinator,
    required GamePhaseManager gamePhaseManager,
    required EffectProcessor effectProcessor,
    required ActivePlayerManager activePlayerManager,
    required CardsSelectionManagerService cardsSelectionManagerService,
  }) => PlayerTurnSceneCoordinator(
      playerCoordinator: playerCoordinators.firstWhere(
        (pc) => pc.playerInfoCoordinator.isActive,
      ),
      shopCoordinator: createShopCoordinator(
        state: state,
        cardsSelectionManagerService: cardsSelectionManagerService,
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
    );
}