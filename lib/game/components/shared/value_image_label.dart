import 'package:flame/components.dart';
import 'package:card_battler/game/components/shared/reactive_position_component.dart';
import 'package:card_battler/game/models/shared/value_image_label_model.dart';
import 'package:flutter/material.dart';

class ValueImageLabel extends ReactivePositionComponent<ValueImageLabelModel> {
  ValueImageLabel(super.model);

  late TextComponent? _textComponent;

  @override
  void updateDisplay() {
    super.updateDisplay();

    if (!hasChildren) _addTextComponent();

    _textComponent!.text = model.display;
  }

  void _addTextComponent() {
    _textComponent = TextComponent(
    text: 'Empty',
    anchor: Anchor.topLeft,
    position: Vector2(size.x / 2, size.y / 2),
    textRenderer: TextPaint(
      style: TextStyle(
        fontSize: 20,
        color: Colors.white,
        ),
      ),
    );

    add(_textComponent!);
  }
}