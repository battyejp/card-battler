import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/ui/components/card/card.dart';
import 'package:card_battler/game/ui/components/common/flat_button.dart';
import 'package:flame/components.dart';

class ActionableCard extends Card {
  late FlatButton _button;
  final Function()? _onButtonPressed;

  ActionableCard(CardCoordinator coordinator, {Function()? onButtonPressed})
    : _onButtonPressed = onButtonPressed,
      super(coordinator: coordinator);

  String get buttonLabel => "Play";

  bool get buttonDisabled => _button.disabled;

  set buttonDisabled(bool value) => _button.disabled = value;

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
          _onButtonPressed?.call();
        }
      },
    );
    _button.isVisible = false;
    add(_button);
  }
}
