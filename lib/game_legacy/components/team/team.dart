import 'package:card_battler/game_legacy/components/team/bases.dart';
import 'package:card_battler/game_legacy/components/team/players.dart';
import 'package:card_battler/game_legacy/models/team/team_model.dart';
import 'package:flame/components.dart';

class Team extends PositionComponent {
  final TeamModel model;

  Team(this.model);

  @override
  void onLoad() {

    final playersHeight = size.y / 2;
    final players = Players(model.playersModel, showActivePlayer: false)
      ..size = Vector2(size.x, playersHeight)
      ..position = Vector2(0, 0);
    add(players);

    final bases = Bases(model: model.bases)
      ..size = Vector2(size.x, size.y - playersHeight)
      ..position = Vector2(0, players.size.y);
    add(bases);
  }
}