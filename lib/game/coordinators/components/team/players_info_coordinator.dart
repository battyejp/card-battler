import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';

//TODO delete
class PlayersInfoCoordinator {
  PlayersInfoCoordinator({required List<PlayerInfoCoordinator> players})
    : _players = players;

  final List<PlayerInfoCoordinator> _players;

  List<PlayerInfoCoordinator> get players => _players;

  PlayerInfoCoordinator get activePlayer =>
      _players.firstWhere((player) => player.isActive);

  List<PlayerInfoCoordinator> get inactivePlayers =>
      _players.where((player) => !player.isActive).toList();
}
