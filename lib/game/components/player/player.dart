import 'package:card_battler/game/components/player/card_deck.dart';
import 'package:card_battler/game/components/player/card_pile.dart';
import 'package:card_battler/game/components/player/card_hand.dart';
import 'package:card_battler/game/models/player/card_hand_model.dart';
import 'package:card_battler/game/models/player/card_pile_model.dart';
import 'package:flame/components.dart';

class Player extends PositionComponent {
  static const handWidthFactor = 0.6;
  static const pileWidthFactor = (1 - handWidthFactor) / 2;
  static const cardsToDrawOnTap = 5;

  late final CardDeck _deck;
  late final CardHand _hand;
  late final CardPile _discard;

  @override
  bool get debugMode => true;

  @override
  void onLoad() {
    final deckModel = CardPileModel(numberOfCards: 20);
    final handModel = CardHandModel();

    _deck = CardDeck(deckModel, onTap: () => _drawCardsFromDeck())
      ..size = Vector2(size.x * pileWidthFactor, size.y);

    add(_deck);

    _hand = CardHand(handModel)
      ..size = Vector2(size.x * handWidthFactor, size.y)
      ..position = Vector2(_deck.x + _deck.width, 0);

    add(_hand);

    _discard = CardPile(CardPileModel())
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