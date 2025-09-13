import 'package:card_battler/game/services/card/card_selection_service.dart';
import 'package:card_battler/game/ui/components/card/actionable_card.dart';
import 'package:card_battler/game/ui/components/common/flat_button.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class SelectableCard extends ActionableCard with TapCallbacks {
  late CardSelectionService _interactionService;
  late FlatButton _closeButton;

  bool get isCloseButtonVisible => _closeButton.isVisible;
  set isCloseButtonVisible(bool value) => _closeButton.isVisible = value;

  SelectableCard(super.coordinator);

  @override
  void onLoad() {
    super.onLoad();

    _closeButton = FlatButton(
      "Close",
      disabled: false,
      size: Vector2(size.x, 0.1 * size.y),
      position: Vector2(size.x / 2, 0.1 * size.y / 2),
      onReleased: () {
        if (isCloseButtonVisible) {
          _interactionService.onDeselect();
          isCloseButtonVisible = false;
        }
      },
    );

    _closeButton.isVisible = false;
    add(_closeButton);

    _interactionService = CardSelectionService(
      card: this,
      cardsSelectionManagerService: coordinator.selectionManagerService,
      gamePhaseManager: coordinator.gamePhaseManager,
    );
  }

  // {
  // bool Function()? determineIfButtonEnabled,
  // CardInteractionService? cardInteractionService,
  // CardSelectionService? cardSelectionService,) {
  // _determineIfButtonEnabled = determineIfButtonEnabled;
  // _cardInteractionService = cardInteractionService;
  // _cardSelectionService = cardSelectionService;
  //}

  // @override
  // bool onTapUp(TapUpEvent event) => _interactionService.onSelected(event);

  @override
  bool onTapUp(TapUpEvent event) {
    var result = _interactionService.onSelected(event);

    if (result) {
      isCloseButtonVisible = !isCloseButtonVisible;
    }

    return true;
  }

  // @override
  // void onLoad() {
  //   super.onLoad();
  //   _interaction = CardInteractionController.withServices(
  //     this,
  //     determineIfButtonEnabled: _determineIfButtonEnabled,
  //     cardInteractionService: _cardInteractionService,
  //     cardSelectionService: _cardSelectionService,
  //   );
  // }

  // @override
  // void onRemove() {
  //   _interaction?.dispose();
  //   super.onRemove();
  // }
}
