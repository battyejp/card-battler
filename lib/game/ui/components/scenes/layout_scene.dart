import 'package:card_battler/game/ui/components/scenes/layout_stuff/team/base.dart';
import 'package:card_battler/game/ui/components/scenes/layout_stuff/player/card_fan.dart';
import 'package:card_battler/game/ui/components/scenes/layout_stuff/player/card_pile.dart';
import 'package:card_battler/game/ui/components/scenes/layout_stuff/team/team_mate.dart';
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

    // Add a transparent blue background that fills the screen
    add(
      RectangleComponent(
        size: size - Vector2.all(margin * 2),
        paint: Paint()
          ..color = const Color.fromARGB(24, 68, 115, 196), // Transparent blue
        position: Vector2(margin, margin),
      ),
    );

    final cardPile = CardPile(
      position: Vector2(size.x / 7, size.y / 2 + size.y / 2.25),
    );
    add(cardPile);

    final cardPile2 = CardPile(
      position: Vector2(size.x - size.x / 7, size.y / 2 + size.y / 2.25),
    );
    add(cardPile2);

    final cardFan = CardFan(
      position: Vector2(size.x / 2, size.y - 50),
      initialCardCount: 8,
      fanRadius: 100.0,
      cardScale: 0.35,
    );
    add(cardFan);

    final teamMate1 = TeamMate()
      ..position = Vector2(size.x / 5, size.y / 2 + size.y / 6.5);
    add(teamMate1);

    final teamMate2 = TeamMate()
      ..position = Vector2(size.x - size.x / 5, size.y / 2 + size.y / 6);
    add(teamMate2);

    final teamMate3 = TeamMate()..position = Vector2(size.x / 5, size.y / 2);
    add(teamMate3);

    final teamMate4 = TeamMate()
      ..position = Vector2(size.x - size.x / 5, size.y / 2);
    add(teamMate4);

    final base = Base()
      ..size = Vector2(100, 100)
      ..position = Vector2(size.x / 2 - 50, size.y / 2 - 50);
    add(base);
  }
}
