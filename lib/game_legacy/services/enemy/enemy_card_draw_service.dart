import 'package:card_battler/game_legacy/models/shared/card_model.dart';
import 'package:card_battler/game_legacy/models/enemy/enemy_turn_model.dart';
import 'package:card_battler/game_legacy/models/shared/effect_model.dart';
import 'package:card_battler/game_legacy/services/enemy/enemy_turn_manager.dart';

/// Service responsible for managing enemy card drawing logic with turn completion rules
/// Follows the Single Responsibility Principle by focusing solely on card drawing mechanics
abstract class EnemyCardDrawService {
  /// Draws a card from the enemy deck and determines if turn should continue
  /// Returns the drawn card if successful, null if no cards available
  CardModel? drawCard(EnemyTurnModel state);
  
  /// Checks if a card should cause the turn to end based on its effects
  bool shouldEndTurn(CardModel card);
}

/// Default implementation of EnemyCardDrawService
class DefaultEnemyCardDrawService implements EnemyCardDrawService {
  DefaultEnemyTurnManager _turnManager;

  DefaultEnemyCardDrawService(this._turnManager);

  /// Updates the turn manager instance (used for dependency injection)
  void setTurnManager(DefaultEnemyTurnManager turnManager) {
    _turnManager = turnManager;
  }

  @override
  CardModel? drawCard(EnemyTurnModel state) {
    // Don't draw if turn is already finished
    if (_turnManager.isTurnFinished) return null;

    final drawnCard = state.enemyCards.drawCard();
    if (drawnCard == null) return null;

    // Add the drawn card to played cards
    state.playedCards.addCard(drawnCard);

    // Determine if turn should end based on card effects
    if (shouldEndTurn(drawnCard)) {
      _turnManager.markTurnAsFinished();
    }

    return drawnCard;
  }

  @override
  bool shouldEndTurn(CardModel card) {
    // Turn ends if the card does NOT have a drawCard effect
    // Cards with drawCard effects allow the turn to continue
    return !card.effects.any((effect) => effect.type == EffectType.drawCard);
  }
}