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
      // Apply perspective transform to match the drop zone trapezoid
      // The drop zone has back width = 60% of front width
      canvas.save();

      // Move to center for proper rotation
      canvas.translate(size.x / 2, size.y / 2);

      // Create perspective matrix
      final matrix = Matrix4.identity();

      // Set perspective projection (affects how depth is rendered)
      matrix.setEntry(3, 2, -0.0008); // Reduced perspective strength

      // Rotate around X-axis to tilt the card forward
      // Negative = toward viewer (top narrower, bottom wider)
      matrix.rotateX(0.68); // Moderate tilt

      // Scale down slightly to compensate for perspective growth
      matrix.scale(0.85, 0.85, 1.0);

      // Apply the transform
      canvas.transform(matrix.storage);

      // Move back and render
      canvas.translate(-size.x / 2, -size.y / 2);

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
