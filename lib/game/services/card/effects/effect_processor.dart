import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/team_coordinator.dart';
import 'package:card_battler/game/services/card/effects/effect_handler_service.dart';
import 'package:card_battler/game/services/card/effects/effect_target_resolver.dart';

class EffectProcessor {
  EffectProcessor();

  late EffectTargetResolver _targetResolver;
  final EffectHandlerService _effectHandler = EffectHandlerService();

  set teamCoordinator(TeamCoordinator value) {
    _targetResolver = EffectTargetResolver(value);
  }

  void applyCardEffects(CardCoordinator cardCoordinator) {
    for (final effect in cardCoordinator.playEffects.effects) {
      final targets = _targetResolver.resolveTargets(effect);

      for (final target in targets) {
        _effectHandler.applyEffect(target.playerInfoCoordinator, effect);
      }
    }
  }
}
