import 'package:card_battler/game/coordinators/components/team/team_coordinator.dart';
import 'package:card_battler/game/ui/components/team/team_mate.dart';
import 'package:flame/components.dart';

class Team extends PositionComponent {
  Team(TeamCoordinator coordinator) : _coordinator = coordinator;

  final TeamCoordinator _coordinator;

  @override
  void onMount() {
    super.onMount();

    final teamMateWidth = size.x * 0.32;
    final teamMateHeight = size.y * 0.45;
    const margin = 5.0;

    // final border = RectangleComponent(
    //   size: size,
    //   position: Vector2.zero(),
    //   paint: Paint()
    //     ..color = const Color.fromARGB(255, 255, 255, 255)
    //     ..style = PaintingStyle.stroke
    //     ..strokeWidth = 1.0,
    // );
    // add(border);

    final inactivePlayers = _coordinator.inactivePlayers;

    //TODO different layouts based on number of team members
    final teamMate1 = TeamMate(inactivePlayers[0])
      ..size = Vector2(teamMateWidth, teamMateHeight)
      ..position = Vector2(margin, 0);
    add(teamMate1);

    final teamMate2 = TeamMate(inactivePlayers[1])
      ..size = Vector2(teamMateWidth, teamMateHeight)
      ..position = Vector2(size.x - teamMateWidth - margin, 0);
    add(teamMate2);

    final teamMate3 = TeamMate(inactivePlayers[2])
      ..size = Vector2(teamMateWidth, teamMateHeight)
      ..position = Vector2(margin, size.y - teamMateHeight);
    add(teamMate3);

    final teamMate4 = TeamMate(inactivePlayers[3])
      ..size = Vector2(teamMateWidth, teamMateHeight)
      ..position = Vector2(
        size.x - teamMateWidth - margin,
        size.y - teamMateHeight - margin,
      );
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
