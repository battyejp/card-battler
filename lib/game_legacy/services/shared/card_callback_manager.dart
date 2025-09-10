import 'package:card_battler/game_legacy/models/shared/card_model.dart';

/// Manages card callback operations
/// Single responsibility: Card callback setup, clearing, and handling
class CardCallbackManager<T extends CardModel> {
  Function(CardModel)? _onCardPlayed;

  /// Sets the callback to be invoked when a card is played
  void setOnCardPlayed(Function(CardModel)? callback) {
    _onCardPlayed = callback;
  }

  /// Sets up card played callbacks for cards
  void setupCallbacks(List<T> cards) {
    if (cards.isEmpty) return;

    for (final card in cards) {
      card.onCardPlayed = () => _handleCardPlayed(card);
    }
  }

  /// Clears callbacks from a list of cards
  void clearCallbacks(List<T> cards) {
    for (final card in cards) {
      card.onCardPlayed = null;
    }
  }

  /// Internal handler for when a card is played
  void _handleCardPlayed(T card) {
    card.onCardPlayed = null;
    _onCardPlayed?.call(card);
  }
}