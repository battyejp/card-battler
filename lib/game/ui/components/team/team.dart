import 'dart:ui';

import 'package:card_battler/game/ui/components/team/base.dart';
import 'package:card_battler/game/ui/components/team/team_mate.dart';
import 'package:flame/components.dart';

class Team extends PositionComponent {
  Team();

  @override
  void onMount() {
    super.onMount();

    final halfWidth = size.x / 3;
    final halfHeight = size.y / 2;

    final border = RectangleComponent(
      size: size,
      position: Vector2.zero(),
      paint: Paint()
        ..color = const Color.fromARGB(255, 255, 255, 255)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
    add(border);

    final teamMate1 = TeamMate()
      ..size = Vector2(halfWidth, halfHeight)
      ..position = Vector2.zero();
    add(teamMate1);

    final teamMate2 = TeamMate()
      ..size = Vector2(halfWidth, halfHeight)
      ..position = Vector2(size.x - halfWidth, 0);
    add(teamMate2);

    final teamMate3 = TeamMate()
      ..size = Vector2(halfWidth, halfHeight)
      ..position = Vector2(0, halfHeight);
    add(teamMate3);

    final teamMate4 = TeamMate()
      ..size = Vector2(halfWidth, halfHeight)
      ..position = Vector2(size.x - halfWidth, halfHeight);
    add(teamMate4);

    final baseSize = size.x / 3;
    final base = Base()
      ..size = Vector2(baseSize, baseSize)
      ..position = Vector2(
        size.x / 2 - baseSize / 2,
        size.y / 2 - baseSize / 2,
      );
    add(base);
  }
}
