import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/enemy/enemies_coordinator.dart';
import 'package:card_battler/game/coordinators/components/enemy/enemy_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/player_turn_scene_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_display_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_inventory_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/base_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/bases_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/player_stat_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/players_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/team_coordinator.dart';
import 'package:card_battler/game/services/card/cards_selection_manager_service.dart';
import 'package:card_battler/game/services/game_state/game_phase_manager.dart';
import 'package:card_battler/game/services/game_state/game_state_facade.dart';
import 'package:card_battler/game/ui/components/scenes/enemy_turn_scene.dart';
import 'package:card_battler/game/ui/components/scenes/player_turn_scene.dart';
import 'package:flame/game.dart';

/// Service responsible for managing scene transitions and routing operations
/// This class handles all navigation logic, following the Single Responsibility Principle
class RouterService {
  static final RouterService _instance = RouterService._internal();
  factory RouterService() => _instance;
  RouterService._internal();

  RouterComponent? _router;
  PlayerTurnScene? _playerTurnScene;
  //final GameStateManager _gameStateManager = GameStateManager();

  //TODO split this up as massive and probbaly move as not the router services responsibility
  var playerTurnSceneCoordinator = PlayerTurnSceneCoordinator(
    playerCoordinator: PlayerCoordinator(
      handCardsCoordinator: CardListCoordinator<CardCoordinator>(
        cardCoordinators: [],
      ),
      deckCardsCoordinator: CardListCoordinator<CardCoordinator>(
        cardCoordinators: GameStateFacade
            .instance
            .state
            .activePlayer
            .deckCards
            .allCards
            .map(
              (card) => CardCoordinator(
                card.copy(),
                CardsSelectionManagerService.instance,
              ),
            )
            .toList(),
      ),
      discardCardsCoordinator: CardListCoordinator<CardCoordinator>(
        cardCoordinators: [],
      ),
      playerInfoCoordinator: PlayerInfoCoordinator(
        model: GameStateFacade.instance.state.activePlayer,
      ),
      gamePhaseManager: GamePhaseManager.instance,
    ),
    shopCoordinator: ShopCoordinator(
      displayCoordinator: ShopDisplayCoordinator(
        shopCardCoordinators: GameStateFacade
            .instance
            .state
            .shop
            .inventoryCards
            .allCards
            .map(
              (card) => ShopCardCoordinator(
                card,
                CardsSelectionManagerService.instance,
              ),
            )
            .toList(),
        itemsPerRow: 3,
        numberOfRows: 2,
      ),
      inventoryCoordinator: ShopInventoryCoordinator([]),
    ),
    teamCoordinator: TeamCoordinator(
      playersCoordinator: PlayersCoordinator(
        players: GameStateFacade.instance.state.players
            .map((player) => PlayerStatsCoordinator(player: player))
            .toList(),
      ),
      basesCoordinator: BasesCoordinator(
        baseCoordinators: GameStateFacade.instance.state.bases
            .map((base) => BaseCoordinator(model: base))
            .toList(),
      ),
    ),
    enemiesCoordinator: EnemiesCoordinator(
      enemyCoordinators: GameStateFacade.instance.state.enemiesModel.enemies
          .map((enemy) => EnemyCoordinator(model: enemy))
          .toList(),
      deckCardsCoordinator: CardListCoordinator<CardCoordinator>(
        cardCoordinators: GameStateFacade
            .instance
            .state
            .enemiesModel
            .deckCards
            .allCards
            .map(
              (card) => CardCoordinator(
                card.copy(),
                CardsSelectionManagerService.instance,
              ),
            )
            .toList(),
      ),
      playedCardsCoordinator: CardListCoordinator<CardCoordinator>(
        cardCoordinators: [],
      ),
    ),
    gamePhaseManager: GamePhaseManager.instance,
  );

  /// Create and configure the router component with scene routes
  RouterComponent createRouter(
    Vector2 gameSize, {
    Map<String, Route>? additionalRoutes,
  }) {
    _playerTurnScene = PlayerTurnScene(
      playerTurnSceneCoordinator,
      size: gameSize,
    );

    final routes = {
      'playerTurn': Route(() => _playerTurnScene!),
      'enemyTurn': Route(
        () => EnemyTurnScene(
          //model: GameStateModel.instance.enemyTurnArea,
          size: gameSize,
        ),
      ),
    };

    if (additionalRoutes != null) {
      routes.addAll(additionalRoutes);
    }

    _router = RouterComponent(routes: routes, initialRoute: 'playerTurn');

    //_setupPhaseListener();
    return _router!;
  }

  /// Transition to player turn scene
  void goToPlayerTurn() {
    _router?.pushNamed('playerTurn');
  }

  /// Transition to enemy turn scene
  void goToEnemyTurn() {
    _router?.pushNamed('enemyTurn');
  }

  /// Pop current route (generic navigation)
  void pop() {
    _router?.pop();
  }

  /// Set up phase change listener for automatic scene transitions
  // void _setupPhaseListener() {
  //   _gameStateManager.addPhaseChangeListener((previousPhase, newPhase) {
  //     if (newPhase == GamePhase.enemyTurn) {
  //       goToEnemyTurn();
  //     } else if (previousPhase == GamePhase.enemyTurn && newPhase == GamePhase.playerTurn) {
  //       _handleEnemyTurnToPlayerTurn();
  //     }
  //   });
  // }

  /// Handle enemy turn completion with delay (called via phase transitions)
  // void _handleEnemyTurnToPlayerTurn() {
  //   Future.delayed(const Duration(seconds: 1), () {
  //     // Reset the enemy turn state for the next enemy turn
  //     GameStateModel.instance.enemyTurnArea.resetTurn();
  //     _router?.pop();
  //   });
  // }

  /// Get the player turn scene reference (needed for background interactions)
  //PlayerTurnScene? get playerTurnScene => _playerTurnScene;
}
