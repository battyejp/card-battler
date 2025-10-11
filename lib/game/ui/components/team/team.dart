import 'package:card_battler/game/coordinators/components/team/team_coordinator.dart';
import 'package:card_battler/game/ui/components/team/base_sprite.dart';
import 'package:card_battler/game/ui/components/team/team_mate.dart';
import 'package:flame/components.dart';

class Team extends PositionComponent {
  Team(TeamCoordinator coordinator) : _coordinator = coordinator;

  final TeamCoordinator _coordinator;

  @override
  void onMount() {
    super.onMount();

    final halfWidth = size.x / 3;
    final halfHeight = size.y / 2;

    // final border = RectangleComponent(
    //   size: size,
    //   position: Vector2.zero(),
    //   paint: Paint()
    //     ..color = const Color.fromARGB(255, 255, 255, 255)
    //     ..style = PaintingStyle.stroke
    //     ..strokeWidth = 1.0,
    // );
    // add(border);

    const width = 726.0 * 0.5;
    const height = 435.0 * 0.5;
    final baseSprite = BaseSprite();
    baseSprite
      ..scale = Vector2.all(0.5)
      ..position = Vector2(
        size.x / 2 - width / 2,
        size.y / 2 - height / 2 + 50,
      );
    add(baseSprite);

    final inactivePlayers = _coordinator.inactivePlayers;

    //TODO different layouts based on number of team members
    final teamMate1 = TeamMate(inactivePlayers[0])
      ..size = Vector2(halfWidth, halfHeight)
      ..position = Vector2.zero();
    add(teamMate1);

    final teamMate2 = TeamMate(inactivePlayers[1])
      ..size = Vector2(halfWidth, halfHeight)
      ..position = Vector2(size.x - halfWidth, 0);
    add(teamMate2);

    final teamMate3 = TeamMate(inactivePlayers[2])
      ..size = Vector2(halfWidth, halfHeight)
      ..position = Vector2(0, halfHeight);
    add(teamMate3);

    final teamMate4 = TeamMate(inactivePlayers[3])
      ..size = Vector2(halfWidth, halfHeight)
      ..position = Vector2(size.x - halfWidth, halfHeight);
    add(teamMate4);

    // final baseSize = size.x / 3;

    // final bases = Bases(coordinator: _coordinator.basesCoordinator)
    //   ..size = Vector2(baseSize, baseSize)
    //   ..position = Vector2(
    //     size.x / 2 - baseSize / 2,
    //     size.y / 2 - baseSize / 2,
    //   );
    // add(bases);
  }
}
