import 'package:card_battler/game/models/team/bases_model.dart';
import 'package:card_battler/game/models/team/player_stats_model.dart';

class TeamModel {
  final BasesModel _bases;
  final List<PlayerStatsModel> _players;

  TeamModel({required BasesModel bases, required List<PlayerStatsModel> players})
      : _bases = bases,
        _players = players;

  List<PlayerStatsModel> get players => _players;
  BasesModel get bases => _bases;
}