import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shared/cards_model.dart';

/// Manages hand card operations
/// Single responsibility: Hand card management including adding, clearing, and callback setup
class HandService {
  final CardsModel<CardModel> _handCards;

  /// External callback for when cards are played
  Function(CardModel)? onCardPlayed;

  HandService({required CardsModel<CardModel> handCards}) : _handCards = handCards;

  /// Adds cards to hand and sets up their play callbacks
  void addCards(List<CardModel> cards) {
    _setupCardCallbacks(cards);
    _handCards.addCards(cards);
  }

  /// Clears all cards from hand
  void clearCards() {
    _handCards.clearCards();
  }

  /// Gets all cards currently in hand, prepared for discard
  List<CardModel> prepareCardsForDiscard() {
    final cards = _handCards.cards;
    for (var card in cards) {
      card.isFaceUp = false;
      card.onCardPlayed = null; // Clear callbacks when discarding
    }
    return cards;
  }

  /// Checks if hand has cards
  bool get hasCards => _handCards.cards.isNotEmpty;

  /// Sets up card played callbacks for cards
  void _setupCardCallbacks(List<CardModel> cards) {
    for (final card in cards) {
      card.onCardPlayed = () => _onCardPlayedInternal(card);
    }
  }

  /// Internal handler for when a card is played
  void _onCardPlayedInternal(CardModel card) {
    card.onCardPlayed = null;
    onCardPlayed?.call(card);
  }
}