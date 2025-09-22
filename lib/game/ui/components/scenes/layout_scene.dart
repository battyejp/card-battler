import 'package:card_battler/game/ui/components/scenes/layout_stuff/player/card_fan.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Layout extends PositionComponent {
  Layout({required Vector2 size})
    : super(size: size, position: Vector2.zero()) {
    // Set anchor to center to work with router positioning
    anchor = Anchor.center;
  }

  final margin = 20.0;

  @override
  bool get debugMode => false; // Turn off debug mode

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // final cardPile = CardPile(
    //   position: Vector2(size.x / 7, size.y / 2 + size.y / 2.25),
    // );
    // add(cardPile);

    // final cardPile2 = CardPile(
    //   position: Vector2(size.x - size.x / 7, size.y / 2 + size.y / 2.25),
    // );
    // add(cardPile2);

    final cardFan = CardFan(
      position: Vector2(size.x / 2, size.y - 200),
      initialCardCount: 8,
      fanRadius: 100.0,
      cardScale: 0.35,
    )..size = Vector2(100000, 100000);
    add(cardFan);

    // final team = Team()
    //   ..size = Vector2(size.x, size.y / 2.5)
    //   ..position = Vector2(0, size.y / 2 - size.y / 6);
    // add(team);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()
      ..color = const Color.fromARGB(77, 51, 5, 157); // Red with 0.3 opacity
    canvas.drawRect(size.toRect(), paint);
  }
}
