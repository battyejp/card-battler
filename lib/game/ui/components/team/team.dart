import 'package:card_battler/game/coordinators/components/team/team_coordinator.dart';
import 'package:card_battler/game/ui/components/team/players.dart';
import 'package:flame/components.dart';

class Team extends PositionComponent {
  final TeamCoordinator _coordinator;

  Team({required TeamCoordinator coordinator})
    : _coordinator = coordinator;

  @override
  void onLoad() {

    final playersHeight = size.y / 2;
    final players = Players(coordinator: _coordinator.playersCoordinator)
      ..size = Vector2(size.x, playersHeight)
      ..position = Vector2(0, 0);
    add(players);

    // final bases = Bases(model: model.bases)
    //   ..size = Vector2(size.x, size.y - playersHeight)
    //   ..position = Vector2(0, players.size.y);
    // add(bases);
  }
}