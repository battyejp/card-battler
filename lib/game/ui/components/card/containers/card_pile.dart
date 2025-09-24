import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/ui/components/card/card_sprite.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:flame/components.dart';

//TODO do we want empty indicator or card count like old version, perhaps number in middle of top card?
class CardPile extends ReactivePositionComponent<CardListCoordinator> {
  CardPile(
    super.coordinator, {
    required bool isMini, bool showTopCard = false,
    double scale = 1.0,
  }) : _showTopCard = showTopCard,
       _scale = scale,
       _isMini = isMini;

  final bool _showTopCard;
  final double _scale;
  final bool _isMini;

  @override
  void updateDisplay() async {
    super.updateDisplay();

    for (var i = 0; i < coordinator.cardCoordinators.length; i++) {
      final cardCoordinator = coordinator.cardCoordinators[i];
      final cardSprite =
          CardSprite(cardCoordinator, _isMini)
            ..position = Vector2(-i * 1.0 + size.x / 2, -i * 1.0 + size.y / 2)
            ..anchor = Anchor.center
            ..scale = Vector2.all(_scale);
      cardSprite.coordinator.isFaceUp = _showTopCard;
      add(cardSprite);
    }
  }
}
