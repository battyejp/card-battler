import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

class _ButtonDisabler extends PositionComponent with IgnoreEvents {
}

class FlatButton extends ButtonComponent with HasVisibility {
  bool _disabled = false;
  double _opacity = 1.0;
  late final _ButtonDisabler _disabler;
  String _text;
  
  /// Whether the button is disabled (cannot be clicked)
  bool get disabled => _disabled;
  set disabled(bool value) {
    if (_disabled != value) {
      _disabled = value;
      _updateVisualState();
    }
  }

  /// The text displayed on the button
  String get text => _text;
  set text(String value) {
    if (_text != value) {
      _text = value;
      _updateVisualState();
    }
  }

  FlatButton(
    String text, {
    super.size,
    super.onReleased,
    super.position,
    bool disabled = false,
  }) : _disabled = disabled,
       _text = text,
       super(
         button: ButtonBackground(const Color(0xffece8a3)),
         buttonDown: disabled ? ButtonBackground(Colors.grey) : ButtonBackground(Colors.red),
         children: [
           TextComponent(
             text: text,
             textRenderer: TextPaint(
               style: TextStyle(
                 fontSize: (0.5 * size!.y).clamp(1.0, double.infinity),
                 fontWeight: FontWeight.bold,
                 color: const Color(0xffdbaf58),
               ),
             ),
             position: size / 2.0,
             anchor: Anchor.center,
           ),
         ],
         anchor: Anchor.center,
       ) {
    _disabler = _ButtonDisabler();
    if (_disabled) {
      _updateVisualState();
    }
  }

  void _updateVisualState() {
    if (_disabled) {
      // Set opacity to 0.5 for greyed out appearance
      _opacity = 0.5;
      // Add the disabler to prevent all interactions
      if (!children.contains(_disabler)) {
        _disabler.size = size;
        add(_disabler);
      }
      // Update button background to grey
      button = ButtonBackground(Colors.grey);
      buttonDown = ButtonBackground(Colors.grey);
      // Update text color to a darker grey
      final textComponent = children.whereType<TextComponent>().first;
      textComponent.text = _text;
      textComponent.textRenderer = TextPaint(
        style: TextStyle(
          fontSize: (0.5 * size.y).clamp(1.0, double.infinity),
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
        ),
      );
    } else {
      // Restore normal appearance
      _opacity = 1.0;
      // Remove the disabler to allow interactions
      if (children.contains(_disabler)) {
        remove(_disabler);
      }
      button = ButtonBackground(const Color(0xffece8a3));
      buttonDown = ButtonBackground(Colors.red);
      final textComponent = children.whereType<TextComponent>().first;
      textComponent.text = _text;
      textComponent.textRenderer = TextPaint(
        style: TextStyle(
          fontSize: (0.5 * size.y).clamp(1.0, double.infinity),
          fontWeight: FontWeight.bold,
          color: const Color(0xffdbaf58),
        ),
      );
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.saveLayer(null, Paint()..color = Color.fromRGBO(255, 255, 255, _opacity));
    super.render(canvas);
    canvas.restore();
  }
}

class ButtonBackground extends PositionComponent with HasAncestor<FlatButton> {
  final _paint = Paint()..style = PaintingStyle.stroke;

  late double cornerRadius;

  ButtonBackground(Color color) {
    _paint.color = color;
  }

  @override
  void onMount() {
    super.onMount();
    size = ancestor.size;
    cornerRadius = 0.3 * size.y;
    _paint.strokeWidth = 0.05 * size.y;
  }

  @override
  void render(Canvas canvas) {
  late final background = RRect.fromRectAndRadius(
    size.toRect(),
    Radius.circular(cornerRadius),
  );
    canvas.drawRRect(background, _paint);
  }
}