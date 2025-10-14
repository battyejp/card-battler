import 'dart:ui';

import 'package:card_battler/game/ui/components/card/card_sprite.dart';
import 'package:flutter/material.dart';

class InteractiveCardSprite extends CardSprite {
  InteractiveCardSprite(super.fileName, super.isMini);

  bool isSelected = false;
  bool isDraggable = false;
  bool isBeingDragged = false;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (isSelected || isBeingDragged) {
      // Draw a glowing border around the selected/dragged card
      final glowPaint = Paint()
        ..color = isBeingDragged 
            ? const Color.fromARGB(120, 255, 193, 7) // Yellow glow when dragging
            : const Color.fromARGB(120, 0, 255, 0) // Green glow when selected
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8.0
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10.0);

      final rect = Rect.fromLTWH(0, 0, size.x, size.y);
      canvas.drawRect(rect, glowPaint);

      // Draw solid border
      final borderPaint = Paint()
        ..color = isBeingDragged
            ? const Color(0xFFFFD700) // Gold when dragging
            : const Color(0xFF00FF00) // Green when selected
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;

      canvas.drawRect(rect, borderPaint);
    }
  }
}
