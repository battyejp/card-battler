import 'package:card_battler/game/ui/components/card/card_sprite.dart';
import 'package:flutter/material.dart';

class InteractiveCardSprite extends CardSprite {
  InteractiveCardSprite(super.fileName, super.isMini);

  bool isSelected = false;
  bool isDraggable = false;
  bool isPerspectiveMode = false;

  @override
  void render(Canvas canvas) {
    if (isPerspectiveMode) {
      // Apply perspective transform - card tilted forward
      // Create a 3D perspective effect by scaling bottom slightly wider than top
      canvas.save();

      // Create perspective matrix
      final matrix = Matrix4.identity();

      // Apply perspective transform
      // Rotate slightly around X-axis to tilt card toward viewer
      matrix.setEntry(3, 2, -0.001); // Perspective strength
      matrix.rotateX(-0.15); // Tilt forward slightly (negative is toward viewer)

      // Apply the transform
      canvas.transform(matrix.storage);

      super.render(canvas);
      canvas.restore();
    } else {
      super.render(canvas);
    }

    if (isSelected) {
      // Draw a glowing border around the selected card
      final paint = Paint()
        ..color = const Color(0xFF00FF00)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;

      // Draw border around the card, accounting for the center anchor
      final rect = Rect.fromLTWH(0, 0, size.x, size.y);
      canvas.drawRect(rect, paint);
    }
  }
}
