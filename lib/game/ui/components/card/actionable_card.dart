import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/ui/components/card/card.dart';
import 'package:card_battler/game/ui/components/common/flat_button.dart';
import 'package:flame/components.dart';

class ActionableCard extends Card {
  late FlatButton _actionButton;

  ActionableCard(CardCoordinator coordinator) : super(coordinator: coordinator);

  String get buttonLabel => "Play";

  bool get actionButtonDisabled => false;
  set actionButtonDisabled(bool value) => _actionButton.disabled = value;

  bool get isActionButtonVisible => _actionButton.isVisible;
  set isActionButtonVisible(bool value) => _actionButton.isVisible = value;

  @override
  void onLoad() {
    super.onLoad();

    _actionButton = FlatButton(
      buttonLabel,
      disabled: actionButtonDisabled,
      size: Vector2(size.x, 0.1 * size.y),
      position: Vector2(size.x / 2, size.y - (0.1 * size.y) / 2),
      onReleased: () {
        if (!actionButtonDisabled) {
          coordinator.handleCardPlayed();
        }
      },
    );

    _actionButton.isVisible = false;
    add(_actionButton);
  }
}
