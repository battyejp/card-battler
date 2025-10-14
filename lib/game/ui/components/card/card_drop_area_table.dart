import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/painting.dart';

/// A table-style drop area that can display 1 or 2 zones
class CardDropAreaTable extends PositionComponent
    with DragCallbacks, HasVisibility
    implements CardDropArea {
  CardDropAreaTable();

  @override
  bool isHighlighted = false;

  bool isLeftZoneHighlighted = false;
  bool isRightZoneHighlighted = false;

  /// Number of zones to display: 1 or 2
  int numberOfZones = 1;

  /// Returns which zone is highlighted: 0 = single/left zone, 1 = right zone, -1 = none
  int get highlightedZone {
    if (numberOfZones == 1 && isLeftZoneHighlighted) {
      return 0;
    }
    if (numberOfZones == 2) {
      if (isLeftZoneHighlighted) {
        return 0;
      }
      if (isRightZoneHighlighted) {
        return 1;
      }
    }
    return -1;
  }

  /// Call this to update the zone configuration
  void setNumberOfZones(int zones) {
    numberOfZones = zones;
  }

  @override
  void render(Canvas canvas) {
    // Draw the table (trapezoid for perspective)
    final frontWidth = size.x;
    final backWidth = size.x * 0.7; // Back is 70% of front width
    final height = size.y;
    final backOffset = (frontWidth - backWidth) / 2;

    // Main table path
    final tablePath = Path()
      ..moveTo(backOffset, 0) // Top-left
      ..lineTo(backOffset + backWidth, 0) // Top-right
      ..lineTo(frontWidth, height) // Bottom-right
      ..lineTo(0, height) // Bottom-left
      ..close();

    // Draw table base
    final tableFillPaint = Paint()
      ..color = const Color.fromARGB(180, 101, 67, 33)
      ..style = PaintingStyle.fill;
    canvas.drawPath(tablePath, tableFillPaint);

    // Draw table border
    final tableBorderPaint = Paint()
      ..color = const Color.fromARGB(255, 139, 90, 43)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawPath(tablePath, tableBorderPaint);

    // Draw zones on top of the table
    if (numberOfZones == 1) {
      // Single zone - fill the entire table if highlighted
      if (isLeftZoneHighlighted) {
        final zonePaint = Paint()
          ..color = const Color.fromARGB(120, 195, 4, 109)
          ..style = PaintingStyle.fill;
        canvas.drawPath(tablePath, zonePaint);
      }
    } else if (numberOfZones == 2) {
      // Two zones - split down the middle
      final halfFrontWidth = frontWidth / 2;
      final halfBackWidth = backWidth / 2;

      // Left zone
      final leftZonePath = Path()
        ..moveTo(backOffset, 0) // Top-left
        ..lineTo(backOffset + halfBackWidth, 0) // Top-middle
        ..lineTo(halfFrontWidth, height) // Bottom-middle
        ..lineTo(0, height) // Bottom-left
        ..close();

      if (isLeftZoneHighlighted) {
        final leftZonePaint = Paint()
          ..color = const Color.fromARGB(120, 195, 4, 109)
          ..style = PaintingStyle.fill;
        canvas.drawPath(leftZonePath, leftZonePaint);
      }

      // Divider line
      final dividerPaint = Paint()
        ..color = const Color.fromARGB(255, 200, 200, 200)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawLine(
        Offset(backOffset + halfBackWidth, 0),
        Offset(halfFrontWidth, height),
        dividerPaint,
      );

      // Right zone
      final rightZonePath = Path()
        ..moveTo(backOffset + halfBackWidth, 0) // Top-middle
        ..lineTo(backOffset + backWidth, 0) // Top-right
        ..lineTo(frontWidth, height) // Bottom-right
        ..lineTo(halfFrontWidth, height) // Bottom-middle
        ..close();

      if (isRightZoneHighlighted) {
        final rightZonePaint = Paint()
          ..color = const Color.fromARGB(120, 195, 4, 109)
          ..style = PaintingStyle.fill;
        canvas.drawPath(rightZonePath, rightZonePaint);
      }
    }

    // Draw text labels
    if (numberOfZones == 1) {
      _drawText(canvas, 'Play Card Here', size.x / 2, size.y / 2, 24);
    } else {
      _drawText(canvas, 'Option 1', size.x / 4, size.y / 2, 20);
      _drawText(canvas, 'Option 2', size.x * 3 / 4, size.y / 2, 20);
    }
  }

  void _drawText(
    Canvas canvas,
    String text,
    double x,
    double y,
    double fontSize,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: const Color.fromARGB(255, 255, 255, 255),
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(x - textPainter.width / 2, y - textPainter.height / 2),
    );
  }
}

// Base interface for drop areas
abstract class CardDropArea {
  bool get isHighlighted;
  set isHighlighted(bool value);
  bool get isVisible;
  set isVisible(bool value);
  Vector2 get absolutePosition;
  double get width;
  double get height;
}
