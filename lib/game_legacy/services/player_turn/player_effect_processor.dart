import 'package:card_battler/game_legacy/models/player/player_turn_model.dart';
import 'package:card_battler/game_legacy/models/shared/card_model.dart';
import 'package:card_battler/game_legacy/models/shared/effect_model.dart';

/// Service responsible for processing card effects
/// Follows the Single Responsibility Principle by focusing solely on effect application logic
abstract class PlayerEffectProcessor {
  /// Applies all effects from a card to the game state
  void applyCardEffects(CardModel card, PlayerTurnModel state);
}

/// Default implementation of EffectProcessor
class DefaultPlayerEffectProcessor implements PlayerEffectProcessor {
  @override
  void applyCardEffects(CardModel card, PlayerTurnModel state) {
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

  void _handleAttackEffect(EffectModel effect, PlayerTurnModel state) {
  }

  void _handleHealEffect(EffectModel effect, PlayerTurnModel state) {
  }

  void _handleCreditsEffect(EffectModel effect, PlayerTurnModel state) {
    state.playerModel.infoModel.credits.changeValue(effect.value);
  }

  void _handleDamageLimitEffect(EffectModel effect, PlayerTurnModel state) {
  }

  void _handleDrawCardEffect(EffectModel effect, PlayerTurnModel state) {
  }
}