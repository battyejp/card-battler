import 'package:card_battler/game/components/shared/card/card.dart';
import 'package:card_battler/game/components/shared/flat_button.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' hide Card;

class ActionableCard extends Card {
  late FlatButton _button;
  final Function()? onButtonPressed;

  /// The label to display on the button
  @protected
  String get buttonLabel => "Play";

  /// Whether the button should be disabled by default
  @protected
  bool get buttonDisabled => false;

  set buttonDisabled(bool value) => _button.disabled = value;

  ActionableCard(super.cardModel, {this.onButtonPressed});

  bool get isButtonVisible => _button.isVisible;
  set isButtonVisible(bool value) => _button.isVisible = value;

  @override
  void onLoad() {
    super.onLoad();
    _button = addButton(buttonLabel, size.x / 2, () {
      // Handle button press
      onButtonPressed?.call();
    });
    _button.isVisible = false;
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