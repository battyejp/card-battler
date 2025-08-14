import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:card_battler/game/models/base_model.dart';

class Base extends PositionComponent with HasVisibility {
  final BaseModel _model;
  late TextComponent _healthTextComponent;

  Base({required BaseModel model}) : _model = model;

  /// Updates the health display based on the current model state
  void updateDisplay() {
    if (hasChildren && _healthTextComponent.isMounted) {
      _healthTextComponent.text = _model.healthDisplay;
    }
  }

  @override
  bool get debugMode => true;

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
    final paint = Paint()..color = const Color.fromARGB(77, 62, 173, 10); // Red with 0.3 opacity
    canvas.drawRect(size.toRect(), paint);
  }
}