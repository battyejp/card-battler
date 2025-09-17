import 'package:card_battler/game/services/ui/card_selection_service.dart';
import 'package:card_battler/game/ui/components/card/actionable_card.dart';
import 'package:card_battler/game/ui/components/common/flat_button.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class SelectableCard extends ActionableCard with TapCallbacks {
  SelectableCard(super.coordinator);

  late FlatButton _closeButton;

  bool get isCloseButtonVisible => _closeButton.isVisible;
  set isCloseButtonVisible(bool value) => _closeButton.isVisible = value;

  @override
  void onLoad() {
    super.onLoad();

    _closeButton = FlatButton(
      "Close",
      size: Vector2(size.x, 0.1 * size.y),
      position: Vector2(size.x / 2, 0.1 * size.y / 2),
      onReleased: () {
        if (isCloseButtonVisible) {
          cardInteractionService?.onDeselect();
          isCloseButtonVisible = false;
        }
      },
    );

    _closeButton.isVisible = false;
    add(_closeButton);

    cardInteractionService = CardSelectionService(
      card: this,
      cardsSelectionManagerService: coordinator.selectionManagerService,
      gamePhaseManager: coordinator.gamePhaseManager,
      activePlayerManager: coordinator.activePlayerManager,
    );
  }

  @override
  bool onTapUp(TapUpEvent event) {
    final result = cardInteractionService?.onSelected(event) ?? false;

    if (result) {
      isCloseButtonVisible = !isCloseButtonVisible;
    }

    return true;
  }
}
