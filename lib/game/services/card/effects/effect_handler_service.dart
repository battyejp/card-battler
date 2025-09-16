import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';
import 'package:card_battler/game/models/shared/effect_model.dart';

class EffectHandlerService {
  void handleAttackEffect(PlayerInfoCoordinator target, EffectModel effect) {
    target.adjustHealth(effect.value * -1);
  }

  void handleHealEffect(PlayerInfoCoordinator target, EffectModel effect) {
    // Implementation for heal effect
  }

  void handleCreditsEffect(PlayerInfoCoordinator target, EffectModel effect) {
    target.adjustCredits(effect.value);
  }

  void handleDamageLimitEffect(
    PlayerInfoCoordinator target,
    EffectModel effect,
  ) {
    // Implementation for damage limit effect
  }

  void handleDrawCardEffect(
    PlayerInfoCoordinator target,
    EffectModel effect,
  ) {
    // Implementation for draw card effect
  }

  void applyEffect(PlayerInfoCoordinator target, EffectModel effect) {
    switch (effect.type) {
      case EffectType.attack:
        handleAttackEffect(target, effect);
        break;
      case EffectType.heal:
        handleHealEffect(target, effect);
        break;
      case EffectType.credits:
        handleCreditsEffect(target, effect);
        break;
      case EffectType.damageLimit:
        handleDamageLimitEffect(target, effect);
        break;
      case EffectType.drawCard:
        handleDrawCardEffect(target, effect);
        break;
    }
  }
}