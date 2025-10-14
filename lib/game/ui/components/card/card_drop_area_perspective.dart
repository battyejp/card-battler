import 'package:card_battler/game/services/card/card_fan_draggable_service.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/painting.dart';

class CardDragDropAreaPerspective extends PositionComponent
    with DragCallbacks, HasVisibility
    implements CardDropArea {
  CardDragDropAreaPerspective();

  @override
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
    // Create a perspective trapezoid
    // Front (bottom) is wider than back (top)
    final frontWidth = size.x;
    final backWidth = size.x * 0.7; // Back is 60% of front width
    final height = size.y;

    // Calculate the offset to center the trapezoid
    final backOffset = (frontWidth - backWidth) / 2;

    // Define trapezoid points (top-left, top-right, bottom-right, bottom-left)
    final path = Path()
      ..moveTo(backOffset, 0) // Top-left
      ..lineTo(backOffset + backWidth, 0) // Top-right
      ..lineTo(frontWidth, height) // Bottom-right
      ..lineTo(0, height) // Bottom-left
      ..close();

    // Fill the trapezoid
    final fillPaint = Paint()
      ..color = isHighlighted
          ? const Color.fromARGB(180, 195, 4, 109)
          : const Color.fromARGB(180, 101, 67, 33)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // Draw border
    final borderPaint = Paint()
      ..color = isHighlighted
          ? const Color.fromARGB(255, 255, 50, 150)
          : const Color.fromARGB(255, 139, 90, 43)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawPath(path, borderPaint);
  }
}
