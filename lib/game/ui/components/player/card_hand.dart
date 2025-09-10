import 'package:card_battler/game/coordinators/components/cards/cards_coordinator.dart';
import 'package:card_battler/game/ui/components/card/tapable_actionable_card.dart';
import 'package:flame/components.dart';

class CardHand extends PositionComponent {
  final CardsCoordinator _coordinator;

  CardHand({required CardsCoordinator coordinator})
    : _coordinator = coordinator;

  @override
  void onLoad() {
    if (_coordinator.cards.allCards.isEmpty) return;

    final cardWidth = size.x * 0.15;
    final cardHeight = size.y * 0.8;

    final spacing = 20; // Spacing between cards
    final totalWidth =
        (cardWidth * _coordinator.cards.allCards.length) + (spacing * (_coordinator.cards.allCards.length - 1));
    final startX = (size.x - totalWidth) / 2;

    for (var i = 0; i < _coordinator.cards.allCards.length; i++) {
      final cardPosition = Vector2(
        startX + (i * (cardWidth + spacing)),
        (size.y - cardHeight) / 2,
      );
      var cardModel = _coordinator.cards.allCards[i];

      final card =
          TapableActionableCard(
              cardModel,
              onButtonPressed: () {
                //_cardSelectionService?.deselectCard();
                //cardModel.playCard();
              },
            )
            ..size = Vector2(cardWidth, cardHeight)
            ..position = cardPosition;

      add(card);
    }
  }
}
