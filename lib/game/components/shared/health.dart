import 'package:card_battler/game/components/shared/reactive_position_component.dart';
import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:flame/components.dart';

class Health extends ReactivePositionComponent<HealthModel> {
  late TextComponent _textComponent;
  final Anchor _anchor;

  Health(super.model, [this._anchor = Anchor.centerLeft]);

  @override
  bool get debugMode => true;

  @override
  void updateDisplay() {
    super.updateDisplay();

    _textComponent = TextComponent(
      text: model.healthDisplay,
      anchor: _anchor,
    );

    add(_textComponent);
  }
}