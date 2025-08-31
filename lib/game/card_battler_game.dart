import 'package:card_battler/game/components/enemy/enemies.dart';
import 'package:card_battler/game/components/shop/shop.dart';
import 'package:card_battler/game/components/team/team.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/scenes/enemy_turn_scene.dart';
import 'package:card_battler/game/scenes/scene_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'components/player/player.dart';

class CardBattlerGame extends FlameGame {
  GameStateModel? _gameState;
  Vector2? _testSize;
  late final SceneManager _sceneManager;
  Component? _mainGameScene;

  // Default constructor with new game state
  CardBattlerGame();

  // Test-only constructor to set size before onLoad
  CardBattlerGame.withSize(Vector2 testSize) : _testSize = testSize;

  static const double margin = 20.0;
  static const double topLayoutHeightFactor = 0.6;

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
    _gameState!.enemyTurnArea.onTurnFinished = _onEnemyTurnFinished;
    
    // Initialize scene manager
    _sceneManager = SceneManager();
    add(_sceneManager);
    
    _loadGameComponents();
  }

  void _onPlayerCardsDrawn() {
    _showEnemiesTurn();
  }
  
  void _onEnemyTurnFinished() {
    _returnToMainScene();
  }

  void _showEnemiesTurn() {
    // Create enemy turn scene and transition to it
    final enemyTurnScene = EnemyTurnScene(
      model: _gameState!.enemyTurnArea,
      onSceneComplete: _onEnemyTurnFinished,
    );

    _sceneManager.transitionToScene(
      GameSceneType.enemyTurn,
      enemyTurnScene,
    );
  }
  
  void _returnToMainScene() {
    if (_mainGameScene != null) {
      _sceneManager.returnToMainScene(_mainGameScene!);
    }
  }

  void _loadGameComponents() {
    if (_gameState == null) {
      return;
    }

    // Create main game scene component to hold all game components
    _mainGameScene = Component();

    final availableHeight = size.y - (margin * 2);
    final availableWidth = size.x - (margin * 2);
    final topLayoutHeight = availableHeight * topLayoutHeightFactor;
    final bottomLayoutHeight = availableHeight - topLayoutHeight;
    final topPositionY = -1 * (size.y / 2) + margin;

    // Create player component with models from game state
    final player = Player(
      playerModel: _gameState!.player,
      onCardsDrawn: _onPlayerCardsDrawn,
    )
      ..size = Vector2(availableWidth, bottomLayoutHeight)
      ..position = Vector2(
        (0 - size.x / 2) + margin,
        (size.y / 2) - margin - bottomLayoutHeight,
      );

    _mainGameScene!.add(player);

    // Create enemies component with model from game state
    final enemiesWidth = availableWidth * 0.5;
    final enemies = Enemies(model: _gameState!.enemies)
      ..size = Vector2(enemiesWidth, topLayoutHeight)
      ..position = Vector2((0 - enemiesWidth / 2), topPositionY);

    _mainGameScene!.add(enemies);

    // Create shop component with model from game state
    final shopWidth = availableWidth * 0.5 / 2;
    final shop = Shop(_gameState!.shop)
      ..size = Vector2(shopWidth, topLayoutHeight)
      ..position = Vector2(enemies.position.x + enemiesWidth, topPositionY);

    _mainGameScene!.add(shop);

    // Create team component with model from game state
    final team = Team(_gameState!.team)
      ..size = Vector2(shopWidth, topLayoutHeight)
      ..position = Vector2(0 - enemiesWidth / 2 - shopWidth, topPositionY);

    _mainGameScene!.add(team);
    
    // Set the main scene as the current scene
    _sceneManager.transitionToScene(GameSceneType.main, _mainGameScene!);
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
