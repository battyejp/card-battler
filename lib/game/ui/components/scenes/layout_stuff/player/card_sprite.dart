import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class CardSprite extends SpriteComponent {
  CardSprite(Vector2 position, String fileName, this.name)
    : super(position: position, anchor: Anchor.center) {
    _fileName = fileName;
  }

  final String name;
  late String _fileName;
  bool _isSelected = false;

  bool get isSelected => _isSelected;

  void setSelected(bool selected) {
    _isSelected = selected;
  }

  CardSprite clone() => CardSprite(position.clone(), _fileName, name)
    ..angle = angle
    ..scale = scale.clone()
    ..anchor = anchor;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(_fileName); //TODO can we just load once
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (_isSelected) {
      // Draw a glowing border around the selected card
      final paint = Paint()
        ..color =
            const Color(0xFF00FF00) // Bright green
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;

      // Draw border around the card, accounting for the center anchor
      final rect = Rect.fromLTWH(
        0, // Left edge relative to center
        0, // Top edge relative to center
        size.x, // Width
        size.y, // Height
      );
      canvas.drawRect(rect, paint);
    }
  }
}
