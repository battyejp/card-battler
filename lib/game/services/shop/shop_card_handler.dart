import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';

/// Manages card event callbacks and interactions
/// Single responsibility: Card event handling
class ShopCardHandler {
  Function(CardModel)? _cardPlayedCallback;

  // TODO figure out when this should be called
  /// Clears callbacks from a list of cards
  void clearCardCallbacks(List<ShopCardModel> cards) {
    for (final card in cards) {
      card.onCardPlayed = null;
    }
  }

  /// Sets the callback to be invoked when a card is played
  void setCardPlayedCallback(Function(CardModel)? callback) {
    _cardPlayedCallback = callback;
  }

  /// Sets up event listeners on a list of cards
  void setupCardCallbacks(List<ShopCardModel> cards) {
    for (final card in cards) {
      card.onCardPlayed = () => _handleCardPlayed(card);
    }
  }

  /// Handles when a shop card is played
  void _handleCardPlayed(ShopCardModel card) {
    // Clear the callback to prevent multiple invocations
    card.onCardPlayed = null;
    
    // Notify the external callback if it exists
    // TODO test this occurs, might be able to delete
    _cardPlayedCallback?.call(card);
  }
}