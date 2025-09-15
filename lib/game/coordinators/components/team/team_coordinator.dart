import 'package:card_battler/game/coordinators/components/team/bases_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/players_info_coordinator.dart';

class TeamCoordinator {
  final PlayersInfoCoordinator _playersInfoCoordinator;
  final BasesCoordinator _basesCoordinator;

  TeamCoordinator({
    required PlayersInfoCoordinator playersInfoCoordinator,
    required BasesCoordinator basesCoordinator,
  }) : _playersInfoCoordinator = playersInfoCoordinator,
       _basesCoordinator = basesCoordinator;

  PlayersInfoCoordinator get playersInfoCoordinator => _playersInfoCoordinator;
  BasesCoordinator get basesCoordinator => _basesCoordinator;
}
