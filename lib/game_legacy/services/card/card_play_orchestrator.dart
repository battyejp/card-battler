import 'package:card_battler/game_legacy/models/player/player_turn_model.dart';
import 'package:card_battler/game_legacy/models/shared/card_model.dart';
import 'package:card_battler/game_legacy/models/shop/shop_card_model.dart';
import 'package:card_battler/game_legacy/services/player_turn/player_effect_processor.dart';

/// Service responsible for orchestrating card play across different models
/// Follows the Single Responsibility Principle by focusing solely on coordinating card play logic
abstract class CardPlayOrchestrator {
  /// Handles playing a card, coordinating between different models as needed
  void playCard(CardModel card, PlayerTurnModel state, PlayerEffectProcessor effectProcessor);
}

/// Default implementation of CardPlayOrchestrator
class DefaultCardPlayOrchestrator implements CardPlayOrchestrator {
  @override
  void playCard(CardModel card, PlayerTurnModel state, PlayerEffectProcessor effectProcessor) {
    // Handle different types of cards
    if (card is ShopCardModel) {
      _handleShopCard(card, state);
    } else {
      _handlePlayerCard(card, state);
    }

    // Move card to discard pile
    state.playerModel.discardCards.addCard(card);

    // Apply card effects through the effect processor
    effectProcessor.applyCardEffects(card, state);
  }

  void _handleShopCard(ShopCardModel card, PlayerTurnModel state) {
    // Remove from shop and deduct cost
    card.isFaceUp = false;
    state.shopModel.removeSelectableCardFromShop(card);
    state.playerModel.infoModel.credits.changeValue(-card.cost);
  }

  void _handlePlayerCard(CardModel card, PlayerTurnModel state) {
    // Remove from player's hand
    card.isFaceUp = false;
    state.playerModel.handCards.removeCard(card);
  }
}