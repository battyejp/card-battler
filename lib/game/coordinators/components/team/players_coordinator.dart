import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';

class PlayersCoordinator {
  final List<PlayerInfoCoordinator> _players;

  PlayersCoordinator({required List<PlayerInfoCoordinator> players}) : _players = players;

  List<PlayerInfoCoordinator> get players => _players;

  PlayerInfoCoordinator get activePlayer => _players.firstWhere((player) => player.isActive);
}