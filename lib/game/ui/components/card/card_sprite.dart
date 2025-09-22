import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class CardSprite extends SpriteComponent {
  CardSprite(Vector2 position, String fileName)
    : super(position: position, anchor: Anchor.center) {
    _fileName = fileName;
  }

  bool isSelected = false;

  late String _fileName;

  CardSprite clone() => CardSprite(position.clone(), _fileName)
    ..angle = angle
    ..scale = Vector2.all(1.0)
    ..anchor = anchor;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(_fileName);
  }

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
