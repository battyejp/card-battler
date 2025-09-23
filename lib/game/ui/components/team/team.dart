import 'package:flame/components.dart';
import 'dart:ui';

class Team extends PositionComponent {
  Team();

  @override
  void onMount() {
    super.onMount();

    final halfWidth = size.x / 2;
    final halfHeight = size.y / 2;

    // Top-left quarter (red)
    final topLeft = RectangleComponent(
      size: Vector2(halfWidth, halfHeight),
      position: Vector2(0, 0),
      paint: Paint()..color = const Color(0xFFFF0000),
    );

    // Top-right quarter (green)
    final topRight = RectangleComponent(
      size: Vector2(halfWidth, halfHeight),
      position: Vector2(halfWidth, 0),
      paint: Paint()..color = const Color(0xFF00FF00),
    );

    // Bottom-left quarter (blue)
    final bottomLeft = RectangleComponent(
      size: Vector2(halfWidth, halfHeight),
      position: Vector2(0, halfHeight),
      paint: Paint()..color = const Color(0xFF0000FF),
    );

    // Bottom-right quarter (yellow)
    final bottomRight = RectangleComponent(
      size: Vector2(halfWidth, halfHeight),
      position: Vector2(halfWidth, halfHeight),
      paint: Paint()..color = const Color(0xFFFFFF00),
    );

    add(topLeft);
    add(topRight);
    add(bottomLeft);
    add(bottomRight);
  }
}