import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/ui/components/card/card_deck.dart';
import 'package:card_battler/game/ui/components/card/card_pile.dart';
import 'package:card_battler/game/ui/components/player/card_hand.dart';
import 'package:card_battler/game/ui/components/player/player_info.dart';
import 'package:flame/components.dart';

class Player extends PositionComponent {
  static const _handWidthFactor = 0.6; //TODO not static
  final _pileWidthFactor = (1 - _handWidthFactor) / 2;
  final _infoHeightFactor = 0.1;
  // final _cardsToDrawPerTurn = 5;

  final PlayerCoordinator _coordinator;

  Player({required PlayerCoordinator playerModel}) : _coordinator = playerModel;

  @override
  void onLoad() {
    final infoHeight = size.y * _infoHeightFactor;

    var deck = CardDeck(
      onTap: () => {
        _coordinator.drawCardsFromDeck(5),
      }, //TODO where should 5 live?
      coordinator: _coordinator.deckCardsCoordinator,
    )..size = Vector2(size.x * _pileWidthFactor, size.y);

    add(deck);

    var info =
        PlayerInfo(
            coordinator: _coordinator.playerInfoCoordinator,
            viewMode: PlayerInfoViewMode.detailed,
          )
          ..size = Vector2(size.x * _handWidthFactor, infoHeight)
          ..position = Vector2(deck.x + deck.width, 0);

    add(info);

    var hand = CardHand(_coordinator.handCardsCoordinator)
      ..size = Vector2(size.x * _handWidthFactor, size.y - infoHeight)
      ..position = Vector2(deck.x + deck.width, infoHeight);

    add(hand);

    var discard = CardPile(_coordinator.discardCardsCoordinator, showNext: true)
      ..size = Vector2(size.x * _pileWidthFactor, size.y)
      ..position = Vector2(hand.x + hand.width, 0);

    add(discard);
  }
}
