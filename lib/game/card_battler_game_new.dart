import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/services/card/card_loader_service.dart';
import 'package:card_battler/game/services/game_state/game_state_facade.dart';
import 'package:card_battler/game/services/ui/dialog_service.dart';
import 'package:card_battler/game/services/ui/router_service.dart';
import 'package:card_battler/game/services/ui/scene_service.dart';
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
    var router = SceneService(routerService, dialogService).createRouter(size);
    world.add(router);
  }
}
