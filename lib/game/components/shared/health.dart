import 'package:card_battler/game/components/shared/reactive_position_component.dart';
import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:flame/components.dart';

class Health extends ReactivePositionComponent<HealthModel> {
  late TextComponent _textComponent;

  Health(super.model);

  @override
  bool get debugMode => true;

  @override
  void updateDisplay() {
    super.updateDisplay();

    _textComponent = TextComponent(
      text: model.healthDisplay,
      anchor: Anchor.centerLeft,
    );

    add(_textComponent);
  }
}