import 'dart:ui';

import 'package:card_battler/game/coordinators/components/scenes/player_turn_scene_coordinator.dart';
import 'package:card_battler/game/ui/components/card/containers/card_fan.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:card_battler/game/ui/components/enemy/enemies.dart';
import 'package:flame/components.dart';

class PlayerTurnScene
    extends ReactivePositionComponent<PlayerTurnSceneCoordinator> {
  PlayerTurnScene(super.coordinator, {required Vector2 size}) : _size = size;

  final Vector2 _size;

  //TODO could we just update the player component
  @override
  void updateDisplay() {
    super.updateDisplay();

    final startY = 0 - _size.y / 2;
    final startX = 0 - _size.x / 2;
    final enemiesAvailableHeight = _size.y / 4;
    final availableHeightForCardFan = _size.y / 8 * 3;

    final rect1 = RectangleComponent(
      size: Vector2(_size.x, _size.y / 4),
      position: Vector2(startX, startY),
      paint: Paint()..color = const Color.fromARGB(64, 170, 0, 0),
    );

    final rect2 = RectangleComponent(
      size: Vector2(_size.x, _size.y / 8 * 3),
      position: Vector2(startX, rect1.position.y + rect1.size.y),
      paint: Paint()..color = const Color.fromARGB(64, 0, 170, 0),
    );

    final rect3 = RectangleComponent(
      size: Vector2(_size.x, _size.y / 8 * 3),
      position: Vector2(startX, rect2.position.y + rect2.size.y),
      paint: Paint()..color = const Color.fromARGB(64, 0, 0, 170),
    );

    add(rect1);
    add(rect2);
    add(rect3);

    final enemies = Enemies(coordinator: coordinator.enemiesCoordinator)
      ..size = Vector2(_size.x, enemiesAvailableHeight)
      ..position = Vector2((0 - _size.x / 2), startY);

    add(enemies);

    //TODO figure out these hardcoded values. Probably should be based on fan radius
    final cardFan =
        CardFan(initialCardCount: 7, fanRadius: 150.0, cardScale: 0.35)
          // ..size = Vector2(_size.x, availableHeightForCardFan)
          ..position = Vector2(0, _size.y / 2 - 50);
    add(cardFan);
  }
}
