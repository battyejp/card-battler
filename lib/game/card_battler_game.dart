import 'package:card_battler/game/components/shared/flat_button.dart';
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
  late final FlatButton turnButton;

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
    GameStateModel.instance.playerTurn.playerModel.onCardsDrawn = _onPlayerCardsDrawn;
    GameStateModel.instance.enemyTurnArea.onTurnFinished = _onEnemyTurnFinished;

    world.add(
      router = RouterComponent(
        routes: {
          'playerTurn': Route(() => PlayerTurnScene(model: GameStateModel.instance.playerTurn, size: size)),
          'enemyTurn': Route(() => EnemyTurnScene(model: GameStateModel.instance.enemyTurnArea, size: size)),
          'confirm': OverlayRoute((context, game) { 
            return ConfirmDialog(
              title: 'You still have cards in your hand!',
              onCancel: () {
                router.pop();
              },
              onConfirm: () {
                router.pop();
                _endTurn();
              },
            );
          }),
        },
        initialRoute: 'playerTurn',
      ),
    );

    turnButton = FlatButton(
      'Take Enemy Turn',
      size: Vector2(size.x * 0.3, 0.1 * size.y),
      position: Vector2(0, ((size.y / 2) * -1) + (size.y * 0.1)),
      onReleased: () {
        if (!turnButton.disabled && turnButton.isVisible) {
          CardInteractionController.deselectAny();

          if (GameStateModel.instance.currentPhase == GamePhase.setup) {
            turnButton.text = 'End Turn';
            GameStateModel.instance.currentPhase = GamePhase.enemyTurn;
            router.pushNamed('enemyTurn');
          }
          else if (GameStateModel.instance.currentPhase == GamePhase.playerTurn) {      
            if (GameStateModel.instance.playerTurn.playerModel.handModel.cards.isNotEmpty) {
              router.pushOverlay('confirm');
            }
            else {
              _endTurn();
            }
          }
        }
      }
    );

    turnButton.isVisible = false;
    world.add(turnButton);
  }

  void _endTurn() {
    //TODO clear coins
    //TODO clear Attack
    //TODO might need to shuffle discard back into deck

    GameStateModel.instance.playerTurn.discardHand();

    //TODO fill up shop

    turnButton.isVisible = false;
    turnButton.text = 'Take Enemy Turn';
  }

  void _onPlayerCardsDrawn() {
    turnButton.isVisible = true;
  }
  
  void _onEnemyTurnFinished() {
    Future.delayed(const Duration(seconds: 1), () {
      GameStateModel.instance.currentPhase = GamePhase.playerTurn;
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
