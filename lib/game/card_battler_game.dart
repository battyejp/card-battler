import 'package:card_battler/game/components/enemy/enemies.dart';
import 'package:card_battler/game/components/ui/shop.dart';
import 'package:card_battler/game/components/team/team.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:flame/game.dart';
import 'components/player/player.dart';

class CardBattlerGame extends FlameGame {
  late GameStateModel _gameState;
  Vector2? _testSize;

  // Default constructor with new game state
  CardBattlerGame() {
    _gameState = GameStateModel.newGame();
  }

  // Constructor to create game with existing state (for loading saves)
  CardBattlerGame.withState(GameStateModel gameState) : _gameState = gameState;

  // Test-only constructor to set size before onLoad
  CardBattlerGame.withSize(Vector2 testSize) : _testSize = testSize {
    _gameState = GameStateModel.newGame();
  }

  static const double margin = 20.0;
  static const double topLayoutHeightFactor = 0.6;

  @override
  onLoad() {
    if (_testSize != null) {
      onGameResize(_testSize!);
    }

    _loadGameComponents();
  }

  void _loadGameComponents() {
    final availableHeight = size.y - (margin * 2);
    final availableWidth = size.x - (margin * 2);
    final topLayoutHeight = availableHeight * topLayoutHeightFactor;
    final bottomLayoutHeight = availableHeight - topLayoutHeight;
    final topPositionY = -1 * (size.y / 2) + margin;

    // Create player component with models from game state
    final player = Player(playerModel: _gameState.player)
      ..size = Vector2(availableWidth, bottomLayoutHeight)
      ..position = Vector2(
        (0 - size.x / 2) + margin,
        (size.y / 2) - margin - bottomLayoutHeight,
      );

    world.add(player);

    // Create enemies component with model from game state
    final enemiesWidth = availableWidth * 0.5;
    final enemies = Enemies(model: _gameState.enemies)
      ..size = Vector2(enemiesWidth, topLayoutHeight)
      ..position = Vector2((0 - enemiesWidth / 2), topPositionY);

    world.add(enemies);

    // Create shop component with model from game state
    final shopWidth = availableWidth * 0.5 / 2;
    final shop = Shop(_gameState.shop)
      ..size = Vector2(shopWidth, topLayoutHeight)
      ..position = Vector2(enemies.position.x + enemiesWidth, topPositionY);

    world.add(shop);

    // Create team component with model from game state
    final team = Team(_gameState.team)
      ..size = Vector2(shopWidth, topLayoutHeight)
      ..position = Vector2(0 - enemiesWidth / 2 - shopWidth, topPositionY);

    world.add(team);
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
