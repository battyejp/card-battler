import 'package:flame/components.dart';
import 'dart:ui';

class Bases extends PositionComponent {
  @override
  bool get debugMode => true;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = const Color(0x4DFF0000); // Red with 0.3 opacity
    canvas.drawRect(size.toRect(), paint);
  }
}