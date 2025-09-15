import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/enemy/enemy_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/players_info_coordinator.dart';
import 'package:card_battler/game/models/shared/effect_model.dart';

class EffectProcessor {
  final PlayersInfoCoordinator _playersInfoCoordinator;
  final List<EnemyCoordinator> _enemiesCoordinator;

  EffectProcessor(this._playersInfoCoordinator, this._enemiesCoordinator);

  void applyCardEffects(List<CardCoordinator> cardCoordinators) {
    for (final card in cardCoordinators) {
      for (final effect in card.effects) {
        final targets = _getTargets(effect);

        for (final target in targets) {
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
            case EffectType.damageLimit:
              _handleDamageLimitEffect(target, effect);
              break;
            case EffectType.drawCard:
              _handleDrawCardEffect(target, effect);
              break;
          }
        }
      }
    }
  }

  List<PlayerInfoCoordinator> _getTargets(EffectModel effect) {
    // Example logic to get targets based on effect.target
    switch (effect.target) {
      case EffectTarget.self:
      case EffectTarget.activePlayer:
        return [_playersInfoCoordinator.activePlayer];
      case EffectTarget.allPlayers:
        return _playersInfoCoordinator.players;
      case EffectTarget.nonActivePlayers:
        // Return list of enemy players
        return _playersInfoCoordinator.players
            .where((player) => !player.isActive)
            .toList();
      default:
        return [];
    }
  }

  void _handleAttackEffect(PlayerInfoCoordinator target, EffectModel effect) {
    target.adjustHealth(effect.value * -1);
  }

  void _handleHealEffect(PlayerInfoCoordinator target, EffectModel effect) {}

  void _handleCreditsEffect(PlayerInfoCoordinator target, EffectModel effect) {
    target.adjustCredits(effect.value);
  }

  void _handleDamageLimitEffect(
    PlayerInfoCoordinator target,
    EffectModel effect,
  ) {}

  void _handleDrawCardEffect(
    PlayerInfoCoordinator target,
    EffectModel effect,
  ) {}
}
