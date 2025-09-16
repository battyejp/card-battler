import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/ui/components/card/selectable_card.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:flame/components.dart';

class CardHand extends ReactivePositionComponent<CardListCoordinator> {
  CardHand(super.coordinator);

  @override
  void updateDisplay() {
    super.updateDisplay();

    if (coordinator.cardCoordinators.isEmpty) {
      return;
    }

    final cardWidth = size.x * 0.15;
    final cardHeight = size.y * 0.8;

    final spacing = 20; // Spacing between cards
    final totalWidth =
        (cardWidth * coordinator.cardCoordinators.length) +
        (spacing * (coordinator.cardCoordinators.length - 1));
    final startX = (size.x - totalWidth) / 2;

    for (var i = 0; i < coordinator.cardCoordinators.length; i++) {
      final cardPosition = Vector2(
        startX + (i * (cardWidth + spacing)),
        (size.y - cardHeight) / 2,
      );
      var cardCoordinator = coordinator.cardCoordinators[i];

      final card =
          SelectableCard(
              cardCoordinator,
              // onButtonPressed: () {
              //   //_cardSelectionService?.deselectCard();
              //   //cardModel.playCard();
              // },
            )
            ..size = Vector2(cardWidth, cardHeight)
            ..position = cardPosition;

      add(card);
    }
  }
}
