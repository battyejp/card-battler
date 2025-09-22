import 'package:card_battler/game/ui/components/scenes/layout_stuff/team/base.dart';
import 'package:card_battler/game/ui/components/scenes/layout_stuff/team/team_mate.dart';
import 'package:flame/components.dart';

class Team extends PositionComponent {
  double pos = 80.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final teamMate1 = TeamMate()..position = Vector2(pos, pos);
    add(teamMate1);

    final teamMate2 = TeamMate()..position = Vector2(pos, pos * 4);
    add(teamMate2);

    final teamMate3 = TeamMate()..position = Vector2(pos * 5, pos);
    add(teamMate3);

    final teamMate4 = TeamMate()..position = Vector2(pos * 5, pos * 4);
    add(teamMate4);

    final base = Base()
      ..size = Vector2(100, 100)
      ..position = Vector2(size.x / 2 - 50, size.y / 2 - 50);
    add(base);
  }
}
