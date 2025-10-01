import 'dart:ui';
import 'package:flutter/material.dart';

/// Handles rendering visualization for the card fan draggable area.
/// This class is responsible only for rendering the debug/visualization overlay.
class CardFanVisualizationRenderer {
  CardFanVisualizationRenderer({
    this.showDebugOverlay = true,
    this.overlayColor = const Color.fromARGB(77, 195, 4, 4),
  });

  final bool showDebugOverlay;
  final Color overlayColor;

  /// Renders the debug visualization overlay for the draggable area.
  void render(Canvas canvas, Rect rect) {
    if (!showDebugOverlay) {
      return;
    }

    final paint = Paint()..color = overlayColor;
    canvas.drawRect(rect, paint);
  }
}
