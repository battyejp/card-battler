import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/players_info_coordinator.dart';
import 'package:card_battler/game/services/card/effects/effect_handler_service.dart';
import 'package:card_battler/game/services/card/effects/effect_target_resolver.dart';

class EffectProcessor {
  EffectProcessor();

  late EffectTargetResolver _targetResolver;
  final EffectHandlerService _effectHandler = EffectHandlerService();

  set playersInfoCoordinator(PlayersInfoCoordinator value) {
    _targetResolver = EffectTargetResolver(playersInfoCoordinator: value);
  }

  void applyCardEffects(List<CardCoordinator> cardCoordinators) {
    for (final card in cardCoordinators) {
      for (final effect in card.effects) {
        final targets = _targetResolver.resolveTargets(effect);

        for (final target in targets) {
          _effectHandler.applyEffect(target, effect);
        }
      }
    }
  }
}
