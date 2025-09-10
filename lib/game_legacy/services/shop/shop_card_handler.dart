import 'package:card_battler/game_legacy/models/shop/shop_card_model.dart';
import 'package:card_battler/game_legacy/models/shared/card_model.dart';
import 'package:card_battler/game_legacy/services/shared/card_callback_manager.dart';

/// Manages card event callbacks and interactions
/// Single responsibility: Card event handling
class ShopCardHandler {
  final CardCallbackManager<ShopCardModel> _callbackManager;

  ShopCardHandler() : _callbackManager = CardCallbackManager<ShopCardModel>();

  /// Clears callbacks from a list of cards
  void clearCardCallbacks(List<ShopCardModel> cards) {
    _callbackManager.clearCallbacks(cards);
  }

  /// Sets the callback to be invoked when a card is played
  void setCardPlayedCallback(Function(CardModel)? callback) {
    _callbackManager.setOnCardPlayed(callback);
  }

  /// Sets up event listeners on a list of cards
  void setupCardCallbacks(List<ShopCardModel> cards) {
    _callbackManager.setupCallbacks(cards);
  }
}