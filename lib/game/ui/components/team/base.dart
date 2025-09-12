import 'package:card_battler/game/coordinators/components/team/base_coordinator.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Base extends PositionComponent with HasVisibility {
  final BaseCoordinator _coordinator;

  late TextComponent _healthTextComponent;

  Base({required BaseCoordinator coordinator}) : _coordinator = coordinator;

  /// Updates the health display based on the current model state
  /// TODO not used yet
  void updateDisplay() {
    if (hasChildren && _healthTextComponent.isMounted) {
      _healthTextComponent.text = _coordinator.healthDisplay;
    }
  }

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
      ..color = const Color.fromARGB(77, 62, 173, 10); // Red with 0.3 opacity
    canvas.drawRect(size.toRect(), paint);
  }
}
