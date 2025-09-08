import 'package:card_battler/game/models/player/player_turn_state.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/services/card/effect_processor.dart';

/// Service responsible for orchestrating card play across different models
/// Follows the Single Responsibility Principle by focusing solely on coordinating card play logic
abstract class CardPlayOrchestrator {
  /// Handles playing a card, coordinating between different models as needed
  void playCard(CardModel card, PlayerTurnState state, EffectProcessor effectProcessor);
}

/// Default implementation of CardPlayOrchestrator
class DefaultCardPlayOrchestrator implements CardPlayOrchestrator {
  @override
  void playCard(CardModel card, PlayerTurnState state, EffectProcessor effectProcessor) {
    // Set card face down as it's being played
    card.isFaceUp = false;

    // Handle different types of cards
    if (card is ShopCardModel) {
      _handleShopCard(card, state);
    } else {
      _handlePlayerCard(card, state);
    }

    // Move card to discard pile
    state.playerModel.discardModel.addCard(card);

    // Apply card effects through the effect processor
    effectProcessor.applyCardEffects(card, state);
  }

  void _handleShopCard(ShopCardModel card, PlayerTurnState state) {
    // Remove from shop and deduct cost
    state.shopModel.removeSelectableCardFromShop(card);
    state.playerModel.infoModel.credits.changeValue(-card.cost);
  }

  void _handlePlayerCard(CardModel card, PlayerTurnState state) {
    // Remove from player's hand
    state.playerModel.handModel.removeCard(card);
  }
}