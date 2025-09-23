import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';
import 'package:card_battler/game/models/shared/effect_model.dart';

class EffectHandlerService {
  void _handleAttackEffect(PlayerInfoCoordinator target, EffectModel effect) {
    target.adjustAttack(effect.value);
  }

  void _handleHealEffect(PlayerInfoCoordinator target, EffectModel effect) {
    target.adjustHealth(effect.value);
  }

  void _handleCreditsEffect(PlayerInfoCoordinator target, EffectModel effect) {
    target.adjustCredits(effect.value);
  }

  void _handleDamageEffect(PlayerInfoCoordinator target, EffectModel effect) {
    target.adjustHealth(-effect.value);
  }

  void _handleDrawCardEffect(PlayerInfoCoordinator target, EffectModel effect) {
    // Implementation for draw card effect
  }

  void applyEffect(PlayerInfoCoordinator target, EffectModel effect) {
    switch (effect.type) {
      case EffectType.attack:
        _handleAttackEffect(target, effect);
        break;
      case EffectType.heal:
        _handleHealEffect(target, effect);
        break;
      case EffectType.credits:
        _handleCreditsEffect(target, effect);
        break;
      case EffectType.drawCard:
        _handleDrawCardEffect(target, effect);
        break;
      case EffectType.damage:
        _handleDamageEffect(target, effect);
        break;
      case EffectType.protection:
        break;
    }
  }
}
