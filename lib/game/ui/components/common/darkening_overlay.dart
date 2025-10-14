import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

class DarkeningOverlay extends PositionComponent with HasVisibility {
  DarkeningOverlay({double opacity = 0.5})
      : _opacity = opacity;

  final double _opacity;

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Color.fromARGB(
        (_opacity * 255).toInt(),
        0,
        0,
        0,
      );
    canvas.drawRect(size.toRect(), paint);
  }
}
