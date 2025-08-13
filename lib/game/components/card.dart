import 'package:flame/components.dart';
import 'dart:ui';

class Card extends PositionComponent {
  @override
  bool get debugMode => true;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  final paint = Paint()..color = const Color.fromARGB(77, 21, 6, 193);
    canvas.drawRect(size.toRect(), paint);
  }
}