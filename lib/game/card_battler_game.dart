import 'package:card_battler/game/coordinators/components/shared/turn_button_component_coordinator.dart';
import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/services/card/card_loader_service.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/game/coordinators_manager.dart';
import 'package:card_battler/game/services/ui/dialog_service.dart';
import 'package:card_battler/game/services/ui/router_service.dart';
import 'package:card_battler/game/services/ui/scene_service.dart';
import 'package:card_battler/game/ui/components/shared/turn_button_component.dart';
import 'package:flame/game.dart';

class CardBattlerGame extends FlameGame {
  Vector2? _testSize;
  late final RouterComponent router;

  // Default constructor with new game state
  CardBattlerGame();

  // Test-only constructor to set size before onLoad
  CardBattlerGame.withSize(Vector2 testSize) : _testSize = testSize;

  @override
  Future<void> onLoad() async {
    List<ShopCardModel> shopCards = [];
    List<CardModel> playerDeckCards = [];
    List<CardModel> enemyCards = [];

    if (_testSize != null) {
      onGameResize(_testSize!);
    }

    shopCards = await CardLoaderService.loadCardsFromJson<ShopCardModel>(
      'assets/data/shop_cards.json',
      ShopCardModel.fromJson,
    );

    playerDeckCards = await CardLoaderService.loadCardsFromJson<CardModel>(
      'assets/data/hero_starting_cards.json',
      CardModel.fromJson,
    );

    enemyCards = await CardLoaderService.loadCardsFromJson<CardModel>(
      'assets/data/enemy_cards.json',
      CardModel.fromJson,
    );

    var state = GameStateModel.initialize(
      shopCards,
      playerDeckCards,
      enemyCards,
      [],
    );

    final gamePhaseManager = GamePhaseManager();
    final routerService = RouterService();
    final dialogService = DialogService();
    final playerCoordinatorsManager = CoordinatorsManager(
      gamePhaseManager,
      state,
    );
    var router = SceneService(
      routerService,
      dialogService,
      playerCoordinatorsManager.playerTurnSceneCoordinator,
      playerCoordinatorsManager.enemyTurnSceneCoordinator,
      gamePhaseManager,
    ).createRouter(size);

    var turnButtonComponent =
        TurnButtonComponent(
            TurnButtonComponentCoordinator(
              gamePhaseManager: gamePhaseManager,
              dialogService: dialogService,
            ),
          )
          ..priority = 10
          ..size = Vector2(200, 50)
          ..position = Vector2(0, ((size.y / 2) * -1) + (size.y * 0.05));

    turnButtonComponent.priority = 10;
    router.add(turnButtonComponent);
    world.add(router);
  }
}
