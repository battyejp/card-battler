import 'package:card_battler/game/coordinators/player/player_coordinator.dart';
import 'package:card_battler/game/ui/components/card/card_deck.dart';
import 'package:card_battler/game/ui/components/card/card_pile.dart';
import 'package:card_battler/game/ui/components/player/card_hand.dart';
import 'package:flame/components.dart';

class Player extends PositionComponent {
  static const handWidthFactor = 0.6;
  static const pileWidthFactor = (1 - handWidthFactor) / 2;
  static const infoHeightFactor = 0.1;
  static const cardsToDrawPerTurn = 5;

  final PlayerCoordinator _coordinator;

  Player({required PlayerCoordinator playerModel}) : _coordinator = playerModel;

  @override
  void onLoad() {
    final infoHeight = size.y * infoHeightFactor;

    var deck = CardDeck(
      onTap: () => {},
      coordinator: _coordinator.deckCardsCoordinator,
    )..size = Vector2(size.x * pileWidthFactor, size.y);

    add(deck);
    // _info = Info(_playerModel.infoModel)
    //   ..size = Vector2(size.x * handWidthFactor, infoHeight)
    //   ..position = Vector2(_deck.x + _deck.width, 0);

    // add(_info);

    var hand = CardHand(
      coordinator: _coordinator.handCardsCoordinator,
    )
      ..size = Vector2(size.x * handWidthFactor, size.y - infoHeight)
      ..position = Vector2(deck.x + deck.width, infoHeight);

    add(hand);

    var discard = CardPile(coordinator: _coordinator.discardCardsCoordinator, showNext: true)
      ..size = Vector2(size.x * pileWidthFactor, size.y)
      ..position = Vector2(hand.x + hand.width, 0);

    add(discard);
  }
}
