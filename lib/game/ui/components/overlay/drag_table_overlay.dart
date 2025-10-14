import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

/// A dynamic overlay that appears when dragging a card, showing a darkened background
/// and a highlighted table area where the card can be played
class DragTableOverlay extends PositionComponent with HasVisibility {
  DragTableOverlay({
    required Vector2 tableAreaSize,
    required Vector2 tableAreaPosition,
  })  : _tableAreaSize = tableAreaSize,
        _tableAreaPosition = tableAreaPosition;

  final Vector2 _tableAreaSize;
  final Vector2 _tableAreaPosition;
  bool isHighlighted = false;

  @override
  void onMount() {
    super.onMount();
    isVisible = false;
  }

  @override
  void render(Canvas canvas) {
    // Draw darkened background overlay
    final backgroundPaint = Paint()
      ..color = const Color.fromARGB(180, 0, 0, 0); // Dark semi-transparent
    canvas.drawRect(size.toRect(), backgroundPaint);

    // Draw the table play area with glow effect
    final tableRect = Rect.fromLTWH(
      _tableAreaPosition.x,
      _tableAreaPosition.y,
      _tableAreaSize.x,
      _tableAreaSize.y,
    );

    // Outer glow effect
    final glowPaint = Paint()
      ..color = isHighlighted
          ? const Color.fromARGB(100, 76, 175, 80) // Green glow when valid
          : const Color.fromARGB(100, 255, 193, 7) // Yellow glow when dragging
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15.0);
    
    canvas.drawRect(tableRect.inflate(10), glowPaint);

    // Main table area
    final tablePaint = Paint()
      ..color = isHighlighted
          ? const Color.fromARGB(220, 76, 175, 80) // Bright green when valid
          : const Color.fromARGB(220, 255, 193, 7) // Bright yellow when dragging
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    
    canvas.drawRect(tableRect, tablePaint);

    // Inner fill with transparency
    final fillPaint = Paint()
      ..color = isHighlighted
          ? const Color.fromARGB(40, 76, 175, 80) // Light green fill
          : const Color.fromARGB(40, 255, 193, 7); // Light yellow fill
    
    canvas.drawRect(tableRect, fillPaint);

    // Draw center line pattern to indicate play zone
    final patternPaint = Paint()
      ..color = isHighlighted
          ? const Color.fromARGB(80, 255, 255, 255)
          : const Color.fromARGB(60, 255, 255, 255)
      ..strokeWidth = 2.0;

    // Horizontal dashed line in center
    final centerY = _tableAreaPosition.y + _tableAreaSize.y / 2;
    final dashWidth = 20.0;
    final dashSpace = 10.0;
    var startX = _tableAreaPosition.x;
    
    while (startX < _tableAreaPosition.x + _tableAreaSize.x) {
      canvas.drawLine(
        Offset(startX, centerY),
        Offset((startX + dashWidth).clamp(
          _tableAreaPosition.x,
          _tableAreaPosition.x + _tableAreaSize.x,
        ), centerY),
        patternPaint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  /// Updates the highlight state based on whether the card can be dropped
  void updateHighlight(bool canDrop) {
    isHighlighted = canDrop;
  }

  /// Shows the overlay when dragging starts
  void show() {
    isVisible = true;
  }

  /// Hides the overlay when dragging ends
  void hide() {
    isVisible = false;
    isHighlighted = false;
  }
}
