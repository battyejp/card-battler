import 'package:card_battler/game/components/player/deck.dart';
import 'package:card_battler/game/components/player/discard.dart';
import 'package:card_battler/game/components/player/hand.dart';
import 'package:flame/components.dart';

class Player extends PositionComponent {
  static const handWidthFactor = 0.6;
  static const deckWidthFactor = (1 - handWidthFactor) / 2;

  @override
  bool get debugMode => true;

  @override
  void onLoad() {
    final deck = Deck()
      ..size = Vector2(size.x * deckWidthFactor, size.y);

    add(deck);

    final hand = Hand()
      ..size = Vector2(size.x * handWidthFactor, size.y)
      ..position = Vector2(deck.x + deck.width, 0);

    add(hand);

    final discard = Discard()
      ..size = Vector2(size.x * deckWidthFactor, size.y)
      ..position = Vector2(hand.x + hand.width, 0);

    add(discard);
  }
}