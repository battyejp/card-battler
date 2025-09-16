import 'package:card_battler/game/coordinators/components/shared/turn_button_component_coordinator.dart';
import 'package:card_battler/game/services/card/cards_selection_manager_service.dart';
import 'package:card_battler/game/ui/components/common/flat_button.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:flame/components.dart';

class TurnButtonComponent
    extends ReactivePositionComponent<TurnButtonComponentCoordinator> {
  bool loadingComplete = false;
  late FlatButton _turnButton;
  final CardsSelectionManagerService _cardsSelectionManagerService;

  TurnButtonComponent(
    super.coordinator, {
    required CardsSelectionManagerService cardsSelectionManagerService,
  }) : _cardsSelectionManagerService = cardsSelectionManagerService;

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
      onReleased: () {
        if (_cardsSelectionManagerService.hasSelection) {
          _cardsSelectionManagerService.selectionService?.onDeselect();
        }

        coordinator.handleTurnButtonPressed();
      },
    );

    _turnButton.isVisible = coordinator.buttonVisible;
    add(_turnButton);
  }
}
