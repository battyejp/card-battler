import 'package:card_battler/game/components/shared/card_deck.dart';
import 'package:card_battler/game/components/shared/card_pile.dart';
import 'package:card_battler/game/components/player/card_hand.dart';
import 'package:card_battler/game/components/player/info.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:flame/components.dart';

class Player extends PositionComponent {
  static const handWidthFactor = 0.6;
  static const pileWidthFactor = (1 - handWidthFactor) / 2;
  static const infoHeightFactor = 0.1;

  final PlayerModel _playerModel;
  final void Function()? onCardsDrawn;
  final void Function(CardModel)? onHandCardTapped;

  late final CardDeck _deck;
  late final CardHand _hand;
  late final CardPile _discard;
  late final Info _info;

  // Default constructor for backward compatibility
  Player({
    required PlayerModel playerModel,
    this.onCardsDrawn,
    this.onHandCardTapped,
  })  : _playerModel = playerModel;

  @override
  bool get debugMode => true;

  @override
  void onLoad() {

    _deck = CardDeck(_playerModel.deckModel, onTap: () => {
      _playerModel.drawCardsFromDeck(),
      onCardsDrawn?.call()
    })
      ..size = Vector2(size.x * pileWidthFactor, size.y);

    add(_deck);

    final infoHeight = size.y * infoHeightFactor;
    _info = Info(_playerModel.infoModel)
      ..size = Vector2(size.x * handWidthFactor, infoHeight)
      ..position = Vector2(_deck.x + _deck.width, 0);

    add(_info);

    _hand = CardHand(_playerModel.handModel, onCardTapped: onHandCardTapped)
      ..size = Vector2(size.x * handWidthFactor, size.y - infoHeight)
      ..position = Vector2(_deck.x + _deck.width, infoHeight);

    add(_hand);

    _discard = CardPile(_playerModel.discardModel)
      ..size = Vector2(size.x * pileWidthFactor, size.y)
      ..position = Vector2(_hand.x + _hand.width, 0);

    add(_discard);
  }
}