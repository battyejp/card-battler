import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game_legacy/models/game_state_model.dart';

/// Service responsible for card interaction business logic
/// This separates business rules from UI presentation concerns
abstract class CardInteractionService {
  /// Determines if a shop card can be purchased
  bool canPurchaseShopCard(ShopCardModel shopCard);
  
  /// Determines if the play button should be visible for a card
  bool shouldShowPlayButton();
}

/// Default implementation of CardInteractionService
class DefaultCardInteractionService implements CardInteractionService {
  final GameStateModel _gameStateModel;
  
  DefaultCardInteractionService(this._gameStateModel);
  
  @override
  bool canPurchaseShopCard(ShopCardModel shopCard) {
    // Check if player has enough credits
    final selectedPlayer = _gameStateModel.selectedPlayer;
    if (selectedPlayer == null) {
      return false;
    }
    
    return selectedPlayer.infoModel.credits.value >= shopCard.cost;
  }
  
  @override
  bool shouldShowPlayButton() {
    return _gameStateModel.currentPhase == GamePhase.playerTurn;
  }
}