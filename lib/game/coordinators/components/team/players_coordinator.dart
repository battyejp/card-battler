import 'package:card_battler/game/coordinators/components/team/player_stat_coordinator.dart';

class PlayersCoordinator {
  final List<PlayerStatsCoordinator> _players;

  PlayersCoordinator({required List<PlayerStatsCoordinator> players}) : _players = players;

  List<PlayerStatsCoordinator> get players => _players;
}