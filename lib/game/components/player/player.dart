import 'package:card_battler/game/components/player/card_deck.dart';
import 'package:card_battler/game/components/player/card_pile.dart';
import 'package:card_battler/game/components/player/card_hand.dart';
import 'package:card_battler/game/components/player/info.dart';
import 'package:card_battler/game/models/player/card_hand_model.dart';
import 'package:card_battler/game/models/player/card_pile_model.dart';
import 'package:card_battler/game/models/player/info_model.dart';
import 'package:flame/components.dart';

class Player extends PositionComponent {
  static const handWidthFactor = 0.6;
  static const pileWidthFactor = (1 - handWidthFactor) / 2;
  static const cardsToDrawOnTap = 5;
  static const infoHeightFactor = 0.1;

  // Models provided by GameStateModel
  //TODO change to player model
  final InfoModel _infoModel;
  final CardHandModel _handModel;
  final CardPileModel _deckModel;
  final CardPileModel _discardModel;

  late final CardDeck _deck;
  late final CardHand _hand;
  late final CardPile _discard;
  late final Info _info;

  // Default constructor for backward compatibility
  Player({
    required InfoModel infoModel,
    required CardHandModel handModel,
    required CardPileModel deckModel,
    required CardPileModel discardModel,
  })  : _infoModel = infoModel,
        _handModel = handModel,
       _deckModel = deckModel,
       _discardModel = discardModel;

  @override
  bool get debugMode => true;

  @override
  void onLoad() {

    _deck = CardDeck(_deckModel, onTap: () => _drawCardsFromDeck())
      ..size = Vector2(size.x * pileWidthFactor, size.y);

    add(_deck);

    final infoHeight = size.y * infoHeightFactor;
    _info = Info(_infoModel)
      ..size = Vector2(size.x * handWidthFactor, infoHeight)
      ..position = Vector2(_deck.x + _deck.width, 0);

    add(_info);

    _hand = CardHand(_handModel)
      ..size = Vector2(size.x * handWidthFactor, size.y - infoHeight)
      ..position = Vector2(_deck.x + _deck.width, infoHeight);

    add(_hand);

    _discard = CardPile(_discardModel)
      ..size = Vector2(size.x * pileWidthFactor, size.y)
      ..position = Vector2(_hand.x + _hand.width, 0);

    add(_discard);
  }

  void _drawCardsFromDeck() {
    final drawnCards = _deck.model.drawCards(cardsToDrawOnTap);

    if (drawnCards.isNotEmpty) {
      for (final card in drawnCards) {
        card.isFaceUp = true;
      }
      _hand.model.addCards(drawnCards);
    }
  }
}