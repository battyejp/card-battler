import 'package:card_battler/game/coordinators/components/shared/turn_button_component_coordinator.dart';
import 'package:card_battler/game/ui/components/common/flat_button.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:flame/components.dart';

class TurnButtonComponent
    extends ReactivePositionComponent<TurnButtonComponentCoordinator> {
  TurnButtonComponent(super.coordinator);

  bool loadingComplete = false;
  late FlatButton _turnButton;

  @override
  void updateDisplay() {
    //Don't call super to remove components

    if (!loadingComplete) {
      _loadGameComponents();
      loadingComplete = true;
    } else {
      _turnButton
        ..text = coordinator.buttonText
        ..isVisible = coordinator.buttonVisible;
    }
  }

  void _loadGameComponents() {
    _turnButton = FlatButton(
      coordinator.buttonText,
      size: Vector2(size.x, size.y),
      position: Vector2(0, 0),
      onReleased: coordinator.handleTurnButtonPressed,
    );

    _turnButton.isVisible = coordinator.buttonVisible;
    add(_turnButton);
  }
}
