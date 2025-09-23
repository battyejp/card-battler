import 'dart:ui';

import 'package:card_battler/game/ui/components/card/card_sprite.dart';
import 'package:flutter/material.dart';

class InteractiveCardSprite extends CardSprite {
  InteractiveCardSprite(super.fileName);

  bool isSelected = false;
  bool isDraggable = false;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

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
