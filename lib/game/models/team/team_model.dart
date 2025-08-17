import 'package:card_battler/game/models/team/bases_model.dart';

class TeamModel {
  final BasesModel _bases;
  final List<String> _playerNames;

  TeamModel({required BasesModel bases, required List<String> playerNames})
      : _bases = bases,
        _playerNames = playerNames;

  List<String> get playerNames => _playerNames;
  BasesModel get bases => _bases;
}