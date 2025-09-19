import 'dart:ui';

import 'package:card_battler/game/ui/components/scenes/layout_stuff/card_fan.dart';
import 'package:flame/components.dart';

class Layout extends PositionComponent {
  Layout({required Vector2 size})
    : super(size: size, position: Vector2.zero()) {
    // Set anchor to center to work with router positioning
    anchor = Anchor.center;
  }

  final margin = 20.0;

  @override
  bool get debugMode => true; // Turn off debug mode

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add a transparent blue background that fills the screen
    add(
      RectangleComponent(
        size: size - Vector2.all(margin * 2),
        paint: Paint()
          ..color = const Color.fromARGB(24, 68, 115, 196), // Transparent blue
        position: Vector2(margin, margin),
      ),
    );

    final cardFan = CardFan(
      position: Vector2(size.x / 2, size.y / 2 + size.y / 2),
      fanRadius: 200.0, // Reduced from 500.0 to make a smaller circle
    );
    add(cardFan);
  }
}
