import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/services/card/card_loader_service.dart';
import 'package:card_battler/game/services/game_state_facade.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';

class CardBattlerGameNew extends FlameGame with TapCallbacks {
  Vector2? _testSize;
  // late final RouterComponent router;
  // final SceneManager _sceneManager = SceneManager();

  // Default constructor with new game state
  CardBattlerGameNew();

  // Test-only constructor to set size before onLoad
  CardBattlerGameNew.withSize(Vector2 testSize) : _testSize = testSize;

  static const double margin = 20.0;
  static const double topLayoutHeightFactor = 0.6;

  @override
  void onTapUp(TapUpEvent event) {
    //_sceneManager.handleBackgroundDeselection();
    super.onTapUp(event);
  }

  @override
  Future<void> onLoad() async {
    List<ShopCardModel> shopCards = [];
    List<CardModel> playerDeckCards = [];
    List<CardModel> enemyCards = [];

    if (_testSize != null) {
      onGameResize(_testSize!);
    }
    else {
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

      GameStateFacade.instance.initialize(shopCards, playerDeckCards, enemyCards);
    }

    // world.add(
    //   router = _sceneManager.createRouter(size),
    // );
  }
}