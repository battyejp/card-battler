import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/services/scene_manager.dart';
import 'package:flame/game.dart';
import 'package:card_battler/game/components/shared/card/card_interaction_controller.dart';
import 'package:flame/events.dart';

class CardBattlerGame extends FlameGame with TapCallbacks {
  Vector2? _testSize;
  late final RouterComponent router;
  final SceneManager _sceneManager = SceneManager();

  // Default constructor with new game state
  CardBattlerGame();

  // Test-only constructor to set size before onLoad
  CardBattlerGame.withSize(Vector2 testSize) : _testSize = testSize;

  static const double margin = 20.0;
  static const double topLayoutHeightFactor = 0.6;

  @override
  void onTapUp(TapUpEvent event) {
    // Deselect any selected card if the background is tapped
    CardInteractionController.deselectAny();
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
      shopCards = await loadCardsFromJson<ShopCardModel>(
        'assets/data/shop_cards.json',
        ShopCardModel.fromJson,
      );

      playerDeckCards = await loadCardsFromJson<CardModel>(
        'assets/data/hero_starting_cards.json',
        CardModel.fromJson,
      );

      enemyCards = await loadCardsFromJson<CardModel>(
        'assets/data/enemy_cards.json',
        CardModel.fromJson,
      );

      GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);
    }

    world.add(
      router = _sceneManager.createRouter(size),
    );
  }
}
