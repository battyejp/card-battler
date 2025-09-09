import 'package:card_battler/game/models/player/player_turn_state.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shared/effect_model.dart';

/// Service responsible for processing card effects
/// Follows the Single Responsibility Principle by focusing solely on effect application logic
abstract class PlayerEffectProcessor {
  /// Applies all effects from a card to the game state
  void applyCardEffects(CardModel card, PlayerTurnState state);
}

/// Default implementation of EffectProcessor
class DefaultPlayerEffectProcessor implements PlayerEffectProcessor {
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
  }

  void _handleHealEffect(EffectModel effect, PlayerTurnState state) {
  }

  void _handleCreditsEffect(EffectModel effect, PlayerTurnState state) {
    state.playerModel.infoModel.credits.changeValue(effect.value);
  }

  void _handleDamageLimitEffect(EffectModel effect, PlayerTurnState state) {
  }

  void _handleDrawCardEffect(EffectModel effect, PlayerTurnState state) {
  }
}