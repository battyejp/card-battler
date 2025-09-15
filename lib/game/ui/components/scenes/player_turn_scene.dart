import 'package:card_battler/game/coordinators/components/scenes/player_turn_scene_coordinator.dart';
import 'package:card_battler/game/ui/components/enemy/enemies.dart';
import 'package:card_battler/game/ui/components/player/player.dart';
import 'package:card_battler/game/ui/components/shop/shop_display.dart';
import 'package:card_battler/game/ui/components/team/team.dart';
import 'package:flame/components.dart';

class PlayerTurnScene extends PositionComponent {
  final PlayerTurnSceneCoordinator _coordinator;

  final Vector2 _size;
  final double _margin = 20.0;
  final double _topLayoutHeightFactor = 0.6;

  // late FlatButton _turnButton;
  bool loadingComplete = false;

  PlayerTurnScene({
    required Vector2 size,
    required PlayerTurnSceneCoordinator coordinator,
  }) : _size = size,
       _coordinator = coordinator;

  @override
  void onLoad() {
    final availableHeight = _size.y - (_margin * 2);
    final topLayoutHeight = availableHeight * _topLayoutHeightFactor;
    final topPositionY = -1 * (_size.y / 2) + _margin;
    final availableWidth = _size.x - (_margin * 2);
    final bottomLayoutHeight = availableHeight - topLayoutHeight;

    var player = Player(playerModel: _coordinator.playerCoordinator)
      ..size = Vector2(availableWidth, bottomLayoutHeight)
      ..position = Vector2(
        (0 - _size.x / 2) + _margin,
        (_size.y / 2) - _margin - bottomLayoutHeight,
      );

    add(player);

    final enemiesWidth = availableWidth * 0.5;
    final enemies = Enemies(coordinator: _coordinator.enemiesCoordinator)
      ..size = Vector2(enemiesWidth, topLayoutHeight)
      ..position = Vector2((0 - enemiesWidth / 2), topPositionY);

    add(enemies);

    final shopWidth = availableWidth * 0.5 / 2;
    final shop = ShopDisplay(_coordinator.shopCoordinator.displayCoordinator)
      ..size = Vector2(shopWidth, topLayoutHeight)
      ..position = Vector2(enemies.position.x + enemiesWidth, topPositionY);

    add(shop);

    final team = Team(coordinator: _coordinator.teamCoordinator)
      ..size = Vector2(shopWidth, topLayoutHeight)
      ..position = Vector2(0 - enemiesWidth / 2 - shopWidth, topPositionY);

    add(team);
  }
}
