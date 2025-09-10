import 'package:card_battler/game_legacy/models/shared/reactive_model.dart';
import 'package:card_battler/game_legacy/models/team/player_stats_model.dart';

class PlayersModel with ReactiveModel<PlayersModel> {
  final List<PlayerStatsModel> _players;

  PlayersModel({required List<PlayerStatsModel> players})
      : _players = players;

  List<PlayerStatsModel> get players => _players;

  set activePlayer(PlayerStatsModel active) {
    for (var player in _players) {
      player.isActive = (player == active);
    }
    notifyChange();
  }
}