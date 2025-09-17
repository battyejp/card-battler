import 'package:card_battler/game/coordinators/components/enemy/enemy_coordinator.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Enemy extends PositionComponent {
  Enemy({required EnemyCoordinator coordinator}) : _coordinator = coordinator;

  final EnemyCoordinator _coordinator;
  late TextComponent _healthTextComponent;

  @override
  void onLoad() {
    super.onLoad();
    _healthTextComponent = TextComponent(
      text: _coordinator.healthDisplay,
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2),
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
    add(_healthTextComponent);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()
      ..color = const Color.fromARGB(77, 89, 2, 124); // Purple with 0.3 opacity
    canvas.drawRect(size.toRect(), paint);
  }
}
