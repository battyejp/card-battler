import 'package:card_battler/game/components/player/card_pile.dart';
import 'package:card_battler/game/components/player/hand.dart';
import 'package:card_battler/game/models/player/card_pile_model.dart';
import 'package:flame/components.dart';

class Player extends PositionComponent {
  static const handWidthFactor = 0.6;
  static const pileWidthFactor = (1 - handWidthFactor) / 2;

  @override
  bool get debugMode => true;

  @override
  void onLoad() {
    final deck = CardPile(CardPileModel(numberOfCards: 7))
      ..size = Vector2(size.x * pileWidthFactor, size.y);

    add(deck);

    final hand = Hand()
      ..size = Vector2(size.x * handWidthFactor, size.y)
      ..position = Vector2(deck.x + deck.width, 0);

    add(hand);

    final discard = CardPile(CardPileModel())
      ..size = Vector2(size.x * pileWidthFactor, size.y)
      ..position = Vector2(hand.x + hand.width, 0);

    add(discard);
  }
}