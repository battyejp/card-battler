import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/ui/components/card/tapable_actionable_card.dart';
import 'package:flame/components.dart';

class CardHand extends PositionComponent {
  final CardListCoordinator _coordinator;

  CardHand({required CardListCoordinator coordinator})
    : _coordinator = coordinator;

  @override
  void onLoad() {
    if (_coordinator.cardCoordinators.isEmpty) return;

    final cardWidth = size.x * 0.15;
    final cardHeight = size.y * 0.8;

    final spacing = 20; // Spacing between cards
    final totalWidth =
        (cardWidth * _coordinator.cardCoordinators.length) +
        (spacing * (_coordinator.cardCoordinators.length - 1));
    final startX = (size.x - totalWidth) / 2;

    for (var i = 0; i < _coordinator.cardCoordinators.length; i++) {
      final cardPosition = Vector2(
        startX + (i * (cardWidth + spacing)),
        (size.y - cardHeight) / 2,
      );
      var cardCoordinator = _coordinator.cardCoordinators[i];

      final card =
          TapableActionableCard(
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
