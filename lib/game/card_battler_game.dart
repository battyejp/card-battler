import 'package:card_battler/game/components/shared/confirm_dialog.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/scenes/enemy_turn_scene.dart';
import 'package:card_battler/game/scenes/player_turn_scene.dart';
import 'package:flame/game.dart';
import 'package:card_battler/game/components/shared/card/card_interaction_controller.dart';
import 'package:flame/events.dart';

class CardBattlerGame extends FlameGame with TapCallbacks {
  Vector2? _testSize;
  late final RouterComponent router;
  late final PlayerTurnScene _playerTurnScene;

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

    GameStateModel.instance.selectedPlayer = GameStateModel.instance.playerTurn.playerModel;
    GameStateModel.instance.enemyTurnArea.onTurnFinished = _onEnemyTurnFinished;

    _playerTurnScene = PlayerTurnScene(
      model: GameStateModel.instance.playerTurn, 
      size: size,
    );

    world.add(
      router = RouterComponent(
        routes: {
          'playerTurn': Route(() => _playerTurnScene),
          'enemyTurn': Route(() => EnemyTurnScene(model: GameStateModel.instance.enemyTurnArea, size: size)),
          'confirm': OverlayRoute((context, game) { 
            return ConfirmDialog(
              title: 'You still have cards in your hand!',
              onCancel: () {
                router.pop();
              },
              onConfirm: () {
                router.pop();
                GameStateModel.instance.playerTurn.endTurn();
                //_playerTurnScene.onTurnEnded?.call();
              },
            );
          }),
        },
        initialRoute: 'playerTurn',
      ),
    );

  }
  
  void _onEnemyTurnFinished() {
    Future.delayed(const Duration(seconds: 1), () {
      router.pop();
    });
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
