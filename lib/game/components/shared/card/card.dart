
import 'package:card_battler/game/components/shared/flat_button.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Card extends PositionComponent {
  final CardModel cardModel;
  late FlatButton _button;

  @protected
  late TextComponent nameTextComponent;

  /// The label to display on the button
  @protected
  String get buttonLabel => "Play";

  /// Whether the button should be disabled by default
  @protected
  bool get buttonDisabled => false;

  Card(this.cardModel);

  bool get isButtonVisible => _button.isVisible;
  set isButtonVisible(bool value) => _button.isVisible = value;

  @override
  void onLoad() {
    super.onLoad();
    addTextComponent();
    _button = addButton(buttonLabel, size.x / 2, () {
      // Handle button press
    });
    _button.isVisible = false;
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
    final paint = Paint()..color = const Color.fromARGB(255, 22, 6, 193);
    canvas.drawRect(size.toRect(), paint);
  }

  FlatButton addButton(String label, double buttonX, Function()? action) {
    final button = FlatButton(
      label,
      disabled: buttonDisabled,
      size: Vector2(size.x, 0.1 * size.y),
      position: Vector2(buttonX, size.y - (0.1 * size.y) / 2),
      onReleased: () {
        action?.call();
      },
    );
    add(button);
    return button;
  }
}