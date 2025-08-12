import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GameWorld extends World {
  late TextComponent _text;

  GameWorld() {
    _text = TextComponent(
      text: 'hello world',
      anchor: Anchor.center,
      position: Vector2.zero(),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 48,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(_text);
  }

  @override
  void onMount() {
    super.onMount();
    // Center the text in the middle of the screen using parent's size
    final parentSize = (parent is PositionComponent)
        ? (parent as PositionComponent).size
        : Vector2.zero();
    if (parentSize != Vector2.zero()) {
      _text.position = parentSize / 2;
    }
  }
}
