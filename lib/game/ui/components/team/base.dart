import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Base extends PositionComponent {
  @override
  void onLoad() {
    super.onLoad();
    final nameLabel = TextComponent(
      text: "Base: 1/3",
      anchor: Anchor.center,
      position: Vector2(size.x / 2, 20),
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
    add(nameLabel);

    final healthTextComponent = TextComponent(
      text: "HP: 10/10",
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2),
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
    add(healthTextComponent);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()
      ..color = const Color.fromARGB(77, 62, 173, 10); // Red with 0.3 opacity
    canvas.drawRect(size.toRect(), paint);
  }
}
