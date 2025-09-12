import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/enemy/enemies_coordinator.dart';
import 'package:card_battler/game/coordinators/components/enemy/enemy_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/enemy_turn_scene_coordinator.dart';
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

  RouterComponent? _router;
  PlayerTurnScene? _playerTurnScene;
  EnemyTurnScene? _enemyTurnScene;

  //final GameStateManager _gameStateManager = GameStateManager();

  late final PlayersCoordinator playersCoordinator;
  late final PlayerTurnSceneCoordinator playerTurnSceneCoordinator;
  late final EnemyTurnSceneCoordinator enemyTurnSceneCoordinator;

  RouterService._internal() {
    playersCoordinator = PlayersCoordinator(
      players: GameStateFacade.instance.state.players
          .map((player) => PlayerStatsCoordinator(player: player))
          .toList(),
    );

    playerTurnSceneCoordinator = PlayerTurnSceneCoordinator(
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
        playersCoordinator: playersCoordinator,
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

    enemyTurnSceneCoordinator = EnemyTurnSceneCoordinator(
      playedCardsCoordinator: CardListCoordinator<CardCoordinator>(
        cardCoordinators: [],
      ),
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
      playersCoordinator: playersCoordinator,
    );
  }

  /// Create and configure the router component with scene routes
  RouterComponent createRouter(
    Vector2 gameSize, {
    Map<String, Route>? additionalRoutes,
  }) {
    _playerTurnScene = PlayerTurnScene(
      playerTurnSceneCoordinator,
      size: gameSize,
    );
    _enemyTurnScene = EnemyTurnScene(
      coordinator: enemyTurnSceneCoordinator,
      size: gameSize,
    );

    final routes = {
      'playerTurn': Route(() => _playerTurnScene!),
      'enemyTurn': Route(() => _enemyTurnScene!),
    };

    if (additionalRoutes != null) {
      routes.addAll(additionalRoutes);
    }

    _router = RouterComponent(routes: routes, initialRoute: 'playerTurn');

    GamePhaseManager.instance.addPhaseChangeListener(_onGamePhaseChanged);
    return _router!;
  }

  void _onGamePhaseChanged(GamePhase previousPhase, GamePhase newPhase) {
    if (newPhase == GamePhase.enemyTurn) {
      goToEnemyTurn();
    } else if (previousPhase == GamePhase.enemyTurn &&
        newPhase == GamePhase.playerTurn) {
      _handleEnemyTurnToPlayerTurn();
    }
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

  void _handleEnemyTurnToPlayerTurn() {
    Future.delayed(const Duration(seconds: 1), () {
      // Reset the enemy turn state for the next enemy turn
      //GameStateModel.instance.enemyTurnArea.resetTurn();
      pop();
    });
  }

  //TODO think this needs to be called somewhere
  void dispose() {
    GamePhaseManager.instance.removePhaseChangeListener(_onGamePhaseChanged);
  }

  /// Get the player turn scene reference (needed for background interactions)
  //PlayerTurnScene? get playerTurnScene => _playerTurnScene;
}
