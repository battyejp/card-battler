import 'package:card_battler/game/card_battler_game.dart';
import 'package:card_battler/game/components/enemy/enemies.dart';
import 'package:card_battler/game/components/player/player.dart';
import 'package:card_battler/game/components/shop/shop.dart';
import 'package:card_battler/game/components/team/team.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:flame/components.dart';

class PlayerTurnScene extends Component with HasGameReference<CardBattlerGame>{
  //TODO should this have its own model?
  //TODO needs unit tests
  final GameStateModel _gameState;
  final Vector2 _size;

  PlayerTurnScene({required GameStateModel gameState, required Vector2 size})
      : _gameState = gameState,
        _size = size {
    _loadGameComponents();
  }

  static const double margin = 20.0;
  static const double topLayoutHeightFactor = 0.6;

  void _loadGameComponents() {
    final availableHeight = _size.y - (margin * 2);
    final availableWidth = _size.x - (margin * 2);
    final topLayoutHeight = availableHeight * topLayoutHeightFactor;
    final bottomLayoutHeight = availableHeight - topLayoutHeight;
    final topPositionY = -1 * (_size.y / 2) + margin;

    // Create player component with models from game state
    final player = Player(
      playerModel: _gameState.player,
    )
      ..size = Vector2(availableWidth, bottomLayoutHeight)
      ..position = Vector2(
        (0 - _size.x / 2) + margin,
        (_size.y / 2) - margin - bottomLayoutHeight,
      );

    add(player);

    // Create enemies component with model from game state
    final enemiesWidth = availableWidth * 0.5;
    final enemies = Enemies(model: _gameState.enemies)
      ..size = Vector2(enemiesWidth, topLayoutHeight)
      ..position = Vector2((0 - enemiesWidth / 2), topPositionY);

    add(enemies);

    // Create shop component with model from game state
    final shopWidth = availableWidth * 0.5 / 2;
    final shop = Shop(_gameState.shop)
      ..size = Vector2(shopWidth, topLayoutHeight)
      ..position = Vector2(enemies.position.x + enemiesWidth, topPositionY);

    add(shop);

    // Create team component with model from game state
    final team = Team(_gameState.team)
      ..size = Vector2(shopWidth, topLayoutHeight)
      ..position = Vector2(0 - enemiesWidth / 2 - shopWidth, topPositionY);

    add(team);
  }
}