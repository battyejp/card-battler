import 'package:card_battler/game_legacy/models/shared/card_model.dart';
import 'package:card_battler/game_legacy/models/shared/cards_model.dart';
import 'package:card_battler/game_legacy/services/shared/card_callback_manager.dart';

/// Manages hand card operations
/// Single responsibility: Hand card management including adding, clearing, and callback setup
class HandService {
  final CardsModel<CardModel> _handCards;
  final CardCallbackManager<CardModel> _callbackManager;

  /// External callback for when cards are played
  set onCardPlayed(Function(CardModel)? callback) => _callbackManager.setOnCardPlayed(callback);

  HandService({required CardsModel<CardModel> handCards}) 
    : _handCards = handCards,
      _callbackManager = CardCallbackManager<CardModel>();

  /// Adds cards to hand and sets up their play callbacks
  void addCards(List<CardModel> cards) {
    _callbackManager.setupCallbacks(cards);
    _handCards.addCards(cards);
  }

  /// Clears all cards from hand
  void clearCards() {
    _handCards.clearCards();
  }

  /// Gets all cards currently in hand, prepared for discard
  List<CardModel> prepareCardsForDiscard() {
    final cards = _handCards.cards;
    _callbackManager.clearCallbacks(cards);
    for (var card in cards) {
      card.isFaceUp = false;
    }
    return cards;
  }

  /// Checks if hand has cards
  bool get hasCards => _handCards.cards.isNotEmpty;

  /// Clears callbacks from a list of cards
  void clearCardCallbacks(List<CardModel> cards) {
    _callbackManager.clearCallbacks(cards);
  }
}