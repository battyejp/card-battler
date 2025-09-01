import 'package:card_battler/game/components/enemy/enemy_turn_area.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/scenes/enemy_turn_scene.dart';
import 'package:card_battler/game/scenes/player_turn_scene.dart';
import 'package:flame/game.dart';
import 'package:card_battler/game/components/shared/card/card_interaction_controller.dart';
import 'package:flame/events.dart';

class CardBattlerGame extends FlameGame with TapCallbacks {
  GameStateModel? _gameState;
  Vector2? _testSize;
  EnemyTurnArea? _enemyTurnArea;
  late final RouterComponent router;

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

      shopCards = List.generate(
          10,
          (index) => ShopCardModel(name: 'Test Card ${index + 1}', cost: 1),
        );

      playerDeckCards = List.generate(
          10,
          (index) => CardModel(
            name: 'Card ${index + 1}',
            type: 'Player',
            isFaceUp: false,
          ),
        );

        enemyCards = List.generate(
          10,
          (index) => CardModel(
            name: 'Enemy Card ${index + 1}',
            type: 'Enemy',
            isFaceUp: false,
          ),
        );
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
    }

    _gameState = GameStateModel.newGame(shopCards, playerDeckCards, enemyCards);
    //_gameState!.enemyTurnArea.onTurnFinished = _onEnemyTurnFinished;
  
    world.add(
      router = RouterComponent(
        routes: {
          'playerTurn': Route(() => PlayerTurnScene(gameState: _gameState!, size: size)),
          'enemyTurn': Route(() => EnemyTurnScene(model: _gameState!.enemyTurnArea, size: size)),
        },
        initialRoute: 'enemyTurn',
      ),
    );

  }

  void _onPlayerCardsDrawn() {
    if (CardInteractionController.isAnyCardSelected) {
      return;
    }

    _enemyTurnArea = EnemyTurnArea(
      displayDuration: const Duration(seconds: 5),
      onComplete: () {
      },
      model: _gameState!.enemyTurnArea,
    );

    _enemyTurnArea!.size = size;
    camera.viewport.add(_enemyTurnArea!);
  }
  
  void _onEnemyTurnFinished() {
    _enemyTurnArea!.startFadeOut();
  }


  // /// Saves the current game state to JSON
  // Map<String, dynamic> saveGame() {
  //   return _gameState.toJson();
  // }

  // /// Loads a game from JSON data
  // static CardBattlerGame loadGame(Map<String, dynamic> jsonData) {
  //   final gameState = GameStateModel.fromJson(jsonData);
  //   return CardBattlerGame.withState(gameState);
  // }
}
