import 'package:card_battler/game/coordinators/components/team/bases_coordinator.dart';
import 'package:card_battler/game/ui/components/team/base.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Bases extends PositionComponent {
  Bases({required BasesCoordinator coordinator}) : _coordinator = coordinator;

  final BasesCoordinator _coordinator;

  @override
  void onMount() {
    super.onMount();
    removeWhere((component) => true);

    // Calculate space below text for base components
    const textHeight = 40.0; // Reserve space for text
    final baseHeight = size.y - textHeight;
    final baseSize = Vector2(size.x, baseHeight);
    const baseY = textHeight;

    // Create UI components for each base model
    final baseComponents = <Base>[];
    final allBaseCoordinators = _coordinator.allBaseCoordinators;
    for (var i = 0; i < _coordinator.allBaseCoordinators.length; i++) {
      final baseCoordinator = allBaseCoordinators[i];
      final baseComponent = Base(coordinator: baseCoordinator)
        ..size = baseSize
        ..position = Vector2(0, baseY);

      // Only the current (top) base should be visible
      baseComponent.isVisible = (i == 0);
      baseComponents.add(baseComponent);
      add(baseComponent);
    }

    // Create text component with correct styling and positioning
    final textComponent = TextComponent(
      text:
          "Base: ${_coordinator.currentBaseIndex} of ${_coordinator.numberOfBases}",
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
      anchor: Anchor.center,
    );
    textComponent.position = Vector2(size.x / 2, 20);
    add(textComponent);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()
      ..color = const Color(0x4DFF0000); // Red with 0.3 opacity
    canvas.drawRect(size.toRect(), paint);
  }
}
