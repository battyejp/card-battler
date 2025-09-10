import 'package:card_battler/game_legacy/components/shared/reactive_position_component.dart';
import 'package:card_battler/game_legacy/models/shared/health_model.dart';
import 'package:flame/components.dart';

class Health extends ReactivePositionComponent<HealthModel> {
  late TextComponent _textComponent;
  late Anchor _anchor;

  Health(super.model, [Anchor _anchor = Anchor.centerLeft]) {
    this._anchor = _anchor;
  }

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