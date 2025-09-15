import 'package:card_battler/game/coordinators/components/shared/turn_button_component_coordinator.dart';
import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/services/card/card_loader_service.dart';
import 'package:card_battler/game/services/game_state/game_phase_manager.dart';
import 'package:card_battler/game/services/game_state/game_state_facade.dart';
import 'package:card_battler/game/services/player/player_coordinators_manager.dart';
import 'package:card_battler/game/services/ui/dialog_service.dart';
import 'package:card_battler/game/services/ui/router_service.dart';
import 'package:card_battler/game/services/ui/scene_service.dart';
import 'package:card_battler/game/ui/components/shared/turn_button_component.dart';
import 'package:flame/game.dart';

class CardBattlerGameNew extends FlameGame {
  Vector2? _testSize;
  late final RouterComponent router;

  // Default constructor with new game state
  CardBattlerGameNew();

  // Test-only constructor to set size before onLoad
  CardBattlerGameNew.withSize(Vector2 testSize) : _testSize = testSize;

  //TODO does not appear to work
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

    GameStateFacade.instance.initialize(
      shopCards,
      playerDeckCards,
      enemyCards,
      [],
    );

    final routerService = RouterService();
    final dialogService = DialogService();
    final playerCoordinatorsManager = PlayerCoordinatorsManager();
    var router = SceneService(
      routerService,
      dialogService,
      playerCoordinatorsManager.playerTurnSceneCoordinator,
      playerCoordinatorsManager.enemyTurnSceneCoordinator,
    ).createRouter(size);

    var turnButtonComponent =
        TurnButtonComponent(
            TurnButtonComponentCoordinator(
              gamePhaseManager: GamePhaseManager.instance,
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
