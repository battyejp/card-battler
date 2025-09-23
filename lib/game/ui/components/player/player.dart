import 'package:card_battler/game/ui/components/card/containers/card_fan.dart';
import 'package:card_battler/game/ui/components/card/containers/card_pile.dart';
import 'package:flame/components.dart';

class Player extends PositionComponent {
  Player();

  @override
  void onMount() {
    super.onMount();

    final cardFan =
        CardFan(initialCardCount: 7, fanRadius: 150.0, cardScale: 0.35)
          ..size = Vector2(size.x, size.y)
          ..position = Vector2(
            0,
            0 +
                size.y -
                60, //TODO Need to figure out this for all screen sizes, probably based on fan radius
          );
    add(cardFan);

    final deckHeight = size.y * 0.3;
    final deckWidth = size.x / 2 * 0.45;

    final deck = CardPile()
      ..size = Vector2(deckWidth, deckHeight)
      ..position = Vector2(0, size.y - deckHeight);

    add(deck);

    final discardPile = CardPile()
      ..size = Vector2(size.x / 2 * 0.45, deckHeight)
      ..position = Vector2(size.x - deckWidth, size.y - deckHeight);

    add(discardPile);
  }
}
