import 'package:card_battler/game/coordinators/components/scenes/enemy_turn_scene_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/player_turn_scene_coordinator.dart';
import 'package:card_battler/game/services/game_state/game_phase_manager.dart';
import 'package:card_battler/game/ui/components/scenes/enemy_turn_scene.dart';
import 'package:card_battler/game/ui/components/scenes/player_turn_scene.dart';
import 'package:flame/game.dart';

/// Service responsible for managing scene transitions and routing operations
/// This class handles all navigation logic, following the Single Responsibility Principle
class RouterService {
  RouterComponent? _router;
  PlayerTurnScene? _playerTurnScene;
  EnemyTurnScene? _enemyTurnScene;
  // late PlayersInfoCoordinator playersCoordinator;
  // late PlayerTurnSceneCoordinator playerTurnSceneCoordinator;
  // late EnemyTurnSceneCoordinator enemyTurnSceneCoordinator;
  // late EffectProcessor effectProcessor;

  // void initialize() {
  //   playersCoordinator = PlayersInfoCoordinator(
  //     players: GameStateFacade.instance.state!.players
  //         .map((player) => PlayerInfoCoordinator(model: player))
  //         .toList(),
  //   );

  //   //effectProcessor = EffectProcessor(playersCoordinator);

  //   playerTurnSceneCoordinator = PlayerTurnSceneCoordinator(
  //     playerCoordinator: PlayerCoordinator(
  //       handCardsCoordinator: CardListCoordinator<CardCoordinator>(
  //         cardCoordinators: [],
  //       ),
  //       deckCardsCoordinator: CardListCoordinator<CardCoordinator>(
  //         cardCoordinators: GameStateFacade
  //             .instance
  //             .state!
  //             .activePlayer
  //             .deckCards
  //             .allCards
  //             .map(
  //               (card) => CardCoordinator(
  //                 cardModel: card.copy(),
  //                 cardsSelectionManagerService:
  //                     CardsSelectionManagerService.instance,
  //                 gamePhaseManager: GamePhaseManager.instance,
  //               ),
  //             )
  //             .toList(),
  //       ),
  //       discardCardsCoordinator: CardListCoordinator<CardCoordinator>(
  //         cardCoordinators: [],
  //       ),
  //       playerInfoCoordinator: playersCoordinator.activePlayer,
  //       gamePhaseManager: GamePhaseManager.instance,
  //     ),
  //     shopCoordinator: ShopCoordinator(
  //       displayCoordinator: ShopDisplayCoordinator(
  //         shopCardCoordinators: GameStateFacade
  //             .instance
  //             .state!
  //             .shop
  //             .inventoryCards
  //             .allCards
  //             .map(
  //               (card) => ShopCardCoordinator(
  //                 card,
  //                 CardsSelectionManagerService.instance,
  //                 GamePhaseManager.instance,
  //               ),
  //             )
  //             .toList(),
  //         itemsPerRow: 3,
  //         numberOfRows: 2,
  //       ),
  //       inventoryCoordinator: ShopInventoryCoordinator([]),
  //     ),
  //     teamCoordinator: TeamCoordinator(
  //       playersInfoCoordinator: playersCoordinator,
  //       basesCoordinator: BasesCoordinator(
  //         baseCoordinators: GameStateFacade.instance.state!.bases
  //             .map((base) => BaseCoordinator(model: base))
  //             .toList(),
  //       ),
  //     ),
  //     enemiesCoordinator: EnemiesCoordinator(
  //       enemyCoordinators: GameStateFacade.instance.state!.enemiesModel.enemies
  //           .map((enemy) => EnemyCoordinator(model: enemy))
  //           .toList(),
  //       deckCardsCoordinator: CardListCoordinator<CardCoordinator>(
  //         cardCoordinators: GameStateFacade
  //             .instance
  //             .state!
  //             .enemiesModel
  //             .deckCards
  //             .allCards
  //             .map(
  //               (card) => CardCoordinator(
  //                 cardModel: card.copy(),
  //                 cardsSelectionManagerService:
  //                     CardsSelectionManagerService.instance,
  //                 gamePhaseManager: GamePhaseManager.instance,
  //               ),
  //             )
  //             .toList(),
  //       ),
  //       playedCardsCoordinator: CardListCoordinator<CardCoordinator>(
  //         cardCoordinators: [],
  //       ),
  //     ),
  //     gamePhaseManager: GamePhaseManager.instance,
  //     effectProcessor: effectProcessor,
  //   );

  //   enemyTurnSceneCoordinator = EnemyTurnSceneCoordinator(
  //     playedCardsCoordinator: CardListCoordinator<CardCoordinator>(
  //       cardCoordinators: [],
  //     ),
  //     deckCardsCoordinator: CardListCoordinator<CardCoordinator>(
  //       cardCoordinators: GameStateFacade
  //           .instance
  //           .state!
  //           .enemiesModel
  //           .deckCards
  //           .allCards
  //           .map(
  //             (card) => CardCoordinator(
  //               cardModel: card.copy(),
  //               cardsSelectionManagerService:
  //                   CardsSelectionManagerService.instance,
  //               gamePhaseManager: GamePhaseManager.instance,
  //             ),
  //           )
  //           .toList(),
  //     ),
  //     playersInfoCoordinator: playersCoordinator,
  //     effectProcessor: effectProcessor,
  //     gamePhaseManager: GamePhaseManager.instance,
  //   );
  // }

  /// Create and configure the router component with scene routes
  RouterComponent createRouter(
    Vector2 gameSize,
    PlayerTurnSceneCoordinator playerTurnSceneCoordinator,
    EnemyTurnSceneCoordinator enemyTurnSceneCoordinator, {
    Map<String, Route>? additionalRoutes,
  }) {
    //initialize();
    _playerTurnScene = PlayerTurnScene(
      size: gameSize,
      coordinator: playerTurnSceneCoordinator,
    );
    _enemyTurnScene = EnemyTurnScene(
      coordinator: enemyTurnSceneCoordinator,
      size: gameSize,
    );

    final routes = {
      'playerTurn': Route(() => _playerTurnScene!),
      'enemyTurn': Route(() => _enemyTurnScene!),
    };

    _router = RouterComponent(routes: routes, initialRoute: 'playerTurn');
    GamePhaseManager.instance.addPhaseChangeListener(_onGamePhaseChanged);
    return _router!;
  }

  void _onGamePhaseChanged(GamePhase previousPhase, GamePhase newPhase) {
    if (newPhase == GamePhase.enemyTurnWaitingToDrawCards) {
      goToEnemyTurn();
    } else if (previousPhase == GamePhase.enemyTurnWaitingToDrawCards &&
        newPhase == GamePhase.playerTakeActionsTurn) {
      _handleEnemyTurnToPlayerTurn();
    }

    switch (newPhase) {
      case GamePhase.enemyTurnWaitingToDrawCards:
        goToEnemyTurn();
        break;
      case GamePhase.playerTakeActionsTurn:
        goToPlayerTurn();
        break;
      default:
        break;
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
    pop();
  }

  //TODO think this needs to be called somewhere
  void dispose() {
    GamePhaseManager.instance.removePhaseChangeListener(_onGamePhaseChanged);
  }
}
