import 'package:card_battler/game/models/team/bases_model.dart';
import 'package:card_battler/game/models/team/players_model.dart';

class TeamModel {
  final BasesModel _bases;
  final PlayersModel _playersModel;

  TeamModel({required BasesModel bases, required PlayersModel playersModel})
      : _bases = bases,
        _playersModel = playersModel;

  PlayersModel get playersModel => _playersModel;
  BasesModel get bases => _bases;
}