import 'dart:ui';

import 'package:card_battler/game/ui/components/scenes/layout_stuff/card_fan.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/services.dart';

class Layout extends PositionComponent {
  Layout({required Vector2 size})
    : super(size: size, position: Vector2.zero()) {
    // Force anchor to top-left
    anchor = Anchor.topLeft;
  }

  @override
  bool get debugMode => true; // Turn off debug mode

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Force the layout to fill the entire screen
    final gameSize = findGame()?.size ?? size;
    size = gameSize;
    position = Vector2.zero();

    // Debug: print position info
    print('Layout position after setting: $position');
    print('Layout size: $size');
    print('Game size: $gameSize');

    // Force portrait orientation for this scene
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Add a background that accounts for router positioning
    add(
      RectangleComponent(
        size: gameSize,
        paint: Paint()..color = const Color(0xFF1E1E1E), // Dark background
        position: Vector2(
          -gameSize.x / 2,
          -gameSize.y / 2,
        ), // Offset to cover full screen
      ),
    );

    // Load card images
    await Flame.images.loadAll(['card_face_up0.2.png']);

    // Add card fan accounting for centered layout positioning
    final cardFan = CardFan(
      position: Vector2(
        0, // Already centered due to router positioning
        gameSize.y / 2 - 200, // Bottom area relative to centered layout
      ),
      fanRadius: 300.0, // 3 times bigger fan (was 100.0)
      cardScale: 1.6, // Much bigger cards (twice as big as 0.8)
    );
    add(cardFan);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Continuously force position to stay at origin
    if (position != Vector2.zero()) {
      position = Vector2.zero();
    }
  }

  @override
  void onRemove() {
    // Restore landscape when leaving this scene
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.onRemove();
  }
}
