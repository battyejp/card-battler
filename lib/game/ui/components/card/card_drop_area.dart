import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/painting.dart';

class CardDragDropArea extends PositionComponent
    with DragCallbacks, HasVisibility {
  CardDragDropArea();

  bool isHighlighted = false;

  @override
  void onMount() {
    super.onMount();

    final textComponent = TextComponent(
      text: 'Play Card Here',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    textComponent.position = Vector2(size.x / 2, size.y / 2);
    textComponent.anchor = Anchor.center;

    add(textComponent);
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = isHighlighted
          ? const Color.fromARGB(255, 195, 4, 109)
          : const Color.fromARGB(255, 3, 190, 47);
    canvas.drawRect(size.toRect(), paint);
  }
}