import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:card_battler/game/models/enemy/enemy_model.dart';

class Enemy extends PositionComponent {
  final EnemyModel _model;
  late TextComponent _healthTextComponent;

  Enemy({required EnemyModel model}) : _model = model;

  /// Updates the health display based on the current model state
  void updateDisplay() {
    if (hasChildren && _healthTextComponent.isMounted) {
      _healthTextComponent.text = _model.healthDisplay;
    }
  }

  @override
  void onLoad() {
    super.onLoad();
    _healthTextComponent = TextComponent(
      text: _model.healthDisplay,
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
    add(_healthTextComponent);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = const Color.fromARGB(77, 89, 2, 124); // Purple with 0.3 opacity
    canvas.drawRect(size.toRect(), paint);
  }
}