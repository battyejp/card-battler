import 'package:card_battler/game/services/card/card_fan_draggable_service.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/painting.dart';

/// A drop area split into two zones - left and right
/// Used when a card has "Or" operator effects
class CardDragDropAreaDual extends PositionComponent
    with DragCallbacks, HasVisibility
    implements CardDropArea {
  CardDragDropAreaDual();

  @override
  bool isHighlighted = false;

  bool isLeftHighlighted = false;
  bool isRightHighlighted = false;

  /// Returns which zone is highlighted: 0 = left, 1 = right, -1 = none
  int get highlightedZone {
    if (isLeftHighlighted) {
      return 0;
    }
    if (isRightHighlighted) {
      return 1;
    }
    return -1;
  }

  @override
  void onMount() {
    super.onMount();

    // Left zone text
    final leftTextComponent = TextComponent(
      text: 'Option 1',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    leftTextComponent.position = Vector2(size.x / 4, size.y / 2);
    leftTextComponent.anchor = Anchor.center;
    add(leftTextComponent);

    // Right zone text
    final rightTextComponent = TextComponent(
      text: 'Option 2',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    rightTextComponent.position = Vector2(size.x * 3 / 4, size.y / 2);
    rightTextComponent.anchor = Anchor.center;
    add(rightTextComponent);
  }

  @override
  void render(Canvas canvas) {
    final frontWidth = size.x / 2; // Each zone is half width
    final backWidth = frontWidth * 0.6; // Back is 60% of front width
    final height = size.y;
    final backOffset = (frontWidth - backWidth) / 2;

    // Left zone trapezoid
    final leftPath = Path()
      ..moveTo(backOffset, 0) // Top-left
      ..lineTo(backOffset + backWidth, 0) // Top-right
      ..lineTo(frontWidth, height) // Bottom-right
      ..lineTo(0, height) // Bottom-left
      ..close();

    final leftFillPaint = Paint()
      ..color = isLeftHighlighted
          ? const Color.fromARGB(180, 195, 4, 109)
          : const Color.fromARGB(180, 101, 67, 33)
      ..style = PaintingStyle.fill;
    canvas.drawPath(leftPath, leftFillPaint);

    final leftBorderPaint = Paint()
      ..color = isLeftHighlighted
          ? const Color.fromARGB(255, 255, 50, 150)
          : const Color.fromARGB(255, 139, 90, 43)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawPath(leftPath, leftBorderPaint);

    // Right zone trapezoid (offset by half width)
    canvas.save();
    canvas.translate(frontWidth, 0);

    final rightPath = Path()
      ..moveTo(backOffset, 0) // Top-left
      ..lineTo(backOffset + backWidth, 0) // Top-right
      ..lineTo(frontWidth, height) // Bottom-right
      ..lineTo(0, height) // Bottom-left
      ..close();

    final rightFillPaint = Paint()
      ..color = isRightHighlighted
          ? const Color.fromARGB(180, 195, 4, 109)
          : const Color.fromARGB(180, 101, 67, 33)
      ..style = PaintingStyle.fill;
    canvas.drawPath(rightPath, rightFillPaint);

    final rightBorderPaint = Paint()
      ..color = isRightHighlighted
          ? const Color.fromARGB(255, 255, 50, 150)
          : const Color.fromARGB(255, 139, 90, 43)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawPath(rightPath, rightBorderPaint);

    canvas.restore();
  }
}
