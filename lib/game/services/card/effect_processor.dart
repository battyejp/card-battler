import 'package:card_battler/game/models/player/player_turn_state.dart';
import 'package:card_battler/game/models/shared/card_model.dart';

/// Service responsible for processing card effects
/// Follows the Single Responsibility Principle by focusing solely on effect application logic
abstract class EffectProcessor {
  /// Applies all effects from a card to the game state
  void applyCardEffects(CardModel card, PlayerTurnState state);
}

/// Default implementation of EffectProcessor
class DefaultEffectProcessor implements EffectProcessor {
  @override
  void applyCardEffects(CardModel card, PlayerTurnState state) {
    for (final effect in card.effects) {
      switch (effect.type) {
        case EffectType.attack:
          _handleAttackEffect(effect, state);
          break;
        case EffectType.heal:
          _handleHealEffect(effect, state);
          break;
        case EffectType.credits:
          _handleCreditsEffect(effect, state);
          break;
        case EffectType.damageLimit:
          _handleDamageLimitEffect(effect, state);
          break;
        case EffectType.drawCard:
          _handleDrawCardEffect(effect, state);
          break;
      }
    }
  }

  void _handleAttackEffect(EffectModel effect, PlayerTurnState state) {
    // TODO: Implement attack effect handling
    // This would involve determining targets and applying damage
  }

  void _handleHealEffect(EffectModel effect, PlayerTurnState state) {
    // TODO: Implement heal effect handling
    // This would involve determining targets and applying healing
  }

  void _handleCreditsEffect(EffectModel effect, PlayerTurnState state) {
    state.playerModel.infoModel.credits.changeValue(effect.value);
  }

  void _handleDamageLimitEffect(EffectModel effect, PlayerTurnState state) {
    // TODO: Implement damage limit effect handling
    // This would involve setting damage reduction/caps
  }

  void _handleDrawCardEffect(EffectModel effect, PlayerTurnState state) {
    // TODO: Implement draw card effect handling
    // This would involve moving cards from deck to hand
  }
}