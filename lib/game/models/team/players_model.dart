import 'package:card_battler/game/models/team/player_stats_model.dart';

class PlayersModel {
  final List<PlayerStatsModel> _players;

  PlayersModel({required List<PlayerStatsModel> players})
      : _players = players;

  List<PlayerStatsModel> get players => _players;
}