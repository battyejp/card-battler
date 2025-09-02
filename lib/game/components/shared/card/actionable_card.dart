import 'package:card_battler/game/components/shared/card/card.dart';
import 'package:card_battler/game/components/shared/flat_button.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' hide Card;

class ActionableCard extends Card {
  late FlatButton _button;
  final Function()? onButtonPressed;

  @protected
  String get buttonLabel => "Play";

  bool get buttonDisabled => _button.disabled;

  set buttonDisabled(bool value) => _button.disabled = value;

  ActionableCard(super.cardModel, {this.onButtonPressed});

  bool get isButtonVisible => _button.isVisible;
  set isButtonVisible(bool value) => _button.isVisible = value;

  @override
  void onLoad() {
    super.onLoad();
    _button = FlatButton(
      buttonLabel,
      disabled: false,
      size: Vector2(size.x, 0.1 * size.y),
      position: Vector2(size.x / 2, size.y - (0.1 * size.y) / 2),
      onReleased: () {
        if (!buttonDisabled && isButtonVisible) {
          onButtonPressed?.call();
        }
      },
    );
    _button.isVisible = false;
    add(_button);
  }
}