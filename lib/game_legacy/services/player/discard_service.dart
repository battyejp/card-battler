import 'package:card_battler/game_legacy/models/shared/card_model.dart';
import 'package:card_battler/game_legacy/models/shared/cards_model.dart';

/// Manages discard pile operations
/// Single responsibility: Discard pile management including adding cards and transferring to other piles
class DiscardService {
  final CardsModel<CardModel> _discardCards;

  DiscardService({required CardsModel<CardModel> discardCards}) : _discardCards = discardCards;

  /// Adds cards to the discard pile
  void addCards(List<CardModel> cards) {
    _discardCards.addCards(cards);
  }

  /// Removes all cards from discard pile and returns them
  List<CardModel> removeAllCards() {
    final cards = _discardCards.allCards;
    _discardCards.clearCards();
    return cards;
  }

  /// Checks if discard pile has no cards
  bool get hasNoCards => _discardCards.hasNoCards;
}