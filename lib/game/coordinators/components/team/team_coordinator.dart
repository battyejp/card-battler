import 'package:card_battler/game/coordinators/components/team/bases_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/players_coordinator.dart';

class TeamCoordinator {
  final PlayersCoordinator _playersCoordinator;
  final BasesCoordinator _basesCoordinator;

  TeamCoordinator({
    required PlayersCoordinator playersCoordinator,
    required BasesCoordinator basesCoordinator,
  }) : _playersCoordinator = playersCoordinator,
       _basesCoordinator = basesCoordinator;

  PlayersCoordinator get playersCoordinator => _playersCoordinator;
  BasesCoordinator get basesCoordinator => _basesCoordinator;
}
