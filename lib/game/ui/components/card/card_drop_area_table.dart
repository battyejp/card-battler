import 'dart:typed_data';
import 'package:card_battler/game/ui/icon_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_svg/svg.dart';
import 'package:flutter/painting.dart';

/// A table-style drop area that can display 1 or 2 zones
class CardDropAreaTable extends PositionComponent
    with DragCallbacks, HasVisibility
    implements CardDropArea {
  CardDropAreaTable() {
    _rupeeIcon = IconManager.rupee();
    _heartIcon = IconManager.heart();
  }

  late Svg _rupeeIcon;
  late Svg _heartIcon;

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

    // Draw icons with perspective
    if (numberOfZones == 1) {
      // Single zone - large rupee icon in center
      _drawIcon(canvas, _rupeeIcon, size.x / 2, size.y / 2, 80);
    } else {
      // Dual zones - heart on left, rupee on right
      _drawIcon(canvas, _heartIcon, size.x / 4, size.y / 2, 64);
      _drawIcon(canvas, _rupeeIcon, size.x * 3 / 4, size.y / 2, 64);
    }
  }

  void _drawIcon(Canvas canvas, Svg icon, double x, double y, double iconSize) {
    canvas.save();

    // Move to the icon position
    canvas.translate(x, y);

    // Apply perspective transform to make icon appear to lay flat on table
    // The table has perspective with back at 70% width, so we match that
    final matrix = Matrix4.identity();

    // Apply perspective (same strength as table)
    matrix.setEntry(3, 2, -0.0005); // Perspective depth

    // Rotate around X-axis to tilt the icon forward (laying on table)
    matrix.rotateX(-0.3); // Tilt to match table perspective

    // Scale to compensate for perspective distortion
    matrix.scale(1.0, 0.85, 1.0); // Slightly compress vertically

    // Convert Float32List to Float64List
    final matrix64 = Float64List(16)..setAll(0, matrix.storage);
    canvas.transform(matrix64);

    // Translate to center the icon (after transform)
    canvas.translate(-iconSize / 2, -iconSize / 2);

    // Render the SVG at the given size
    icon.renderPosition(canvas, Vector2.zero(), Vector2.all(iconSize));

    canvas.restore();
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
