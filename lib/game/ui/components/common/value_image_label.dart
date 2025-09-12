// import 'package:card_battler/game/models/common/value_image_label_model.dart';
// import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
// import 'package:flame/components.dart';
// import 'package:flutter/material.dart';

// //TODO might get rid of
// class ValueImageLabel extends ReactivePositionComponent<ValueImageLabelModel> {
//   ValueImageLabel(super.model);

//   late TextComponent? _textComponent;

//   @override
//   void updateDisplay() {
//     //Don't call super.updateDisplay(), as will just update label instead of needing to remove and recreate
//     if (!hasChildren) {
//       _addTextComponent(model.display);
//     } else {
//       _textComponent!.text = model.display;
//     }
//   }

//   void _addTextComponent(String text) {
//     _textComponent = TextComponent(
//       text: text,
//       anchor: Anchor.topLeft,
//       position: Vector2(size.x / 2, size.y / 2),
//       textRenderer: TextPaint(
//         style: TextStyle(fontSize: 20, color: Colors.white),
//       ),
//     );

//     add(_textComponent!);
//   }
// }
