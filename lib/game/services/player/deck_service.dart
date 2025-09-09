import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shared/cards_model.dart';

/// Manages deck card operations
/// Single responsibility: Deck card management including drawing and shuffling
class DeckService {
  final CardsModel<CardModel> _deckCards;

  DeckService({required CardsModel<CardModel> deckCards}) : _deckCards = deckCards;

  /// Draws specified number of cards from deck
  List<CardModel> drawCards(int count) {
    return _deckCards.drawCards(count);
  }

  /// Adds cards to the deck and shuffles
  void addCardsAndShuffle(List<CardModel> cards) {
    _deckCards.addCards(cards);
    _deckCards.shuffle();
  }
}