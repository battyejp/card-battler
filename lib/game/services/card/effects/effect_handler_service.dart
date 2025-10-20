import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/models/shared/effect_model.dart';

class EffectHandlerService {
  void _handleAttackEffect(PlayerCoordinator target, EffectModel effect) {
    target.adjustAttack(effect.value);
  }

  void _handleHealEffect(PlayerCoordinator target, EffectModel effect) {
    target.adjustHealth(effect.value);
  }

  void _handleCreditsEffect(PlayerCoordinator target, EffectModel effect) {
    target.adjustCredits(effect.value);
  }

  void _handleDamageEffect(PlayerCoordinator target, int value) {
    target.adjustHealth(-value);
  }

  void _handleDrawCardEffect(PlayerCoordinator target, EffectModel effect) {
    // Implementation for draw card effect
  }

  void applyEffect(PlayerCoordinator target, EffectModel effect) {
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
        final minMaxDamageCardValue = target.getMinCardValue(
          EffectType.maxDamage,
        );
        _handleDamageEffect(target, minMaxDamageCardValue ?? effect.value);
        break;
      // This is a passive effect
      case EffectType.maxDamage:
        break;
    }
  }
}
