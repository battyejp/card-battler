import 'package:card_battler/game/coordinators/player/player_coordinator.dart';
import 'package:card_battler/game/ui/components/card/card_deck.dart';
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
    var deck = CardDeck(
      onTap: () => {},
      coordinator: _coordinator.deckCardsCoordinator,
    )..size = Vector2(size.x * pileWidthFactor, size.y);

    add(deck);

    // final infoHeight = size.y * infoHeightFactor;
    // _info = Info(_playerModel.infoModel)
    //   ..size = Vector2(size.x * handWidthFactor, infoHeight)
    //   ..position = Vector2(_deck.x + _deck.width, 0);

    // add(_info);

    // _hand = CardHand(
    //   _playerModel.handCards,
    // )
    //   ..size = Vector2(size.x * handWidthFactor, size.y - infoHeight)
    //   ..position = Vector2(_deck.x + _deck.width, infoHeight);

    // add(_hand);

    // _discard = CardPile(_playerModel.discardCards)
    //   ..size = Vector2(size.x * pileWidthFactor, size.y)
    //   ..position = Vector2(_hand.x + _hand.width, 0);

    // add(_discard);
  }
}
