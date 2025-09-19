import 'dart:ui';

import 'package:card_battler/game/ui/components/common/flat_button.dart';
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

    final cardFan = CardFan(
      position: Vector2(size.x / 2, size.y + size.y / 10),
      initialCardCount: 5,
    );
    add(cardFan);

    final cardFan1 = CardFan(
      position: Vector2(size.x / 5, size.y / 2 + size.y / 6),
      initialCardCount: 5,
      cardScale: 1.0,
      cardImagePath: 'card_face_up_0.02.png',
      fanRadius: 50.0,
    );
    add(cardFan1);

    final cardFan2 = CardFan(
      position: Vector2(size.x - size.x / 5, size.y / 2 + size.y / 6),
      initialCardCount: 5,
      cardScale: 1.0,
      cardImagePath: 'card_face_up_0.02.png',
      fanRadius: 50.0,
    );
    add(cardFan2);

    final cardFan3 = CardFan(
      position: Vector2(size.x / 5, size.y / 2),
      initialCardCount: 5,
      cardScale: 1.0,
      cardImagePath: 'card_face_up_0.02.png',
      fanRadius: 50.0,
    );
    add(cardFan3);

    final cardFan4 = CardFan(
      position: Vector2(size.x - size.x / 5, size.y / 2),
      initialCardCount: 5,
      cardScale: 1.0,
      cardImagePath: 'card_face_up_0.02.png',
      fanRadius: 50.0,
    );
    add(cardFan4);

    // Add a button in the middle of the screen
    /*final addCardBtn = FlatButton(
      'Add Card',
      size: Vector2(size.x * 0.2, 0.1 * size.y),
      position: Vector2(size.x / 2, size.y / 2),
      onReleased: cardFan.addCard,
    )..anchor = Anchor.center;

    add(addCardBtn);*/
  }
}
