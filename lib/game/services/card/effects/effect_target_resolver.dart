import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/players_info_coordinator.dart';
import 'package:card_battler/game/models/shared/effect_model.dart';

class EffectTargetResolver {
  EffectTargetResolver({
    required PlayersInfoCoordinator playersInfoCoordinator,
  }) : _playersInfoCoordinator = playersInfoCoordinator;

  final PlayersInfoCoordinator _playersInfoCoordinator;

  List<PlayerInfoCoordinator> resolveTargets(EffectModel effect) {
    switch (effect.target) {
      case EffectTarget.self:
      case EffectTarget.activePlayer:
        return [_playersInfoCoordinator.activePlayer];
      case EffectTarget.allPlayers:
        return _playersInfoCoordinator.players;
      case EffectTarget.nonActivePlayers:
        return _playersInfoCoordinator.inactivePlayers;
      default:
        return [];
    }
  }
}