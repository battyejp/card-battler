
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

// class CloseButtonComponent extends PositionComponent with TapCallbacks {
//   final VoidCallback onPressed;
//   late final TextComponent _text;

//   CloseButtonComponent({required this.onPressed}) : super(size: Vector2(24, 24));

//   @override
//   Future<void> onLoad() async {
//     _text = TextComponent(
//       text: '×',
//       anchor: Anchor.center,
//       position: Vector2(size.x / 2, size.y / 2),
//       textRenderer: TextPaint(
//         style: const TextStyle(fontSize: 24, color: Colors.white),
//       ),
//     );
//     add(_text);
//     priority = -1; // hidden by default
//   }

//   void show() => priority = 100000;
//   void hide() => priority = -1;

//   @override
//   bool onTapUp(TapUpEvent event) {
//     onPressed();
//     return true;
//   }
// }

class Card extends PositionComponent {
  final CardModel cardModel;
  @protected
  late TextComponent nameTextComponent;
  // CloseButtonComponent? _closeButton;

  Card(this.cardModel);

  @override
  void onLoad() {
    super.onLoad();
    addTextComponent();
    // _closeButton = CloseButtonComponent(
    //   onPressed: () => CardInteractionController.deselectAny(),
    // )
    //   ..position = Vector2(size.x - 24, 8);
    // add(_closeButton!);
    // _closeButton!.hide();
  }

  @protected
  void addTextComponent() {
    if (cardModel.isFaceUp) {
      createNameTextComponent(Vector2(size.x / 2, size.y / 2));
      add(nameTextComponent);
    } else {
      createBackTextComponent();
      add(nameTextComponent);
    }
  }

  @protected
  void createNameTextComponent(Vector2 position) {
    nameTextComponent = TextComponent(
      text: cardModel.name,
      anchor: Anchor.center,
      position: position,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  @protected
  void createBackTextComponent() {
    nameTextComponent = TextComponent(
      text: "Back",
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = const Color.fromARGB(77, 21, 6, 193);
    canvas.drawRect(size.toRect(), paint);
  }
}