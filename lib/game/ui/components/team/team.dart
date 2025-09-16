import 'package:card_battler/game/coordinators/components/team/team_coordinator.dart';
import 'package:card_battler/game/ui/components/player/player_info.dart';
import 'package:card_battler/game/ui/components/team/bases.dart';
import 'package:card_battler/game/ui/components/team/players.dart';
import 'package:flame/components.dart';

class Team extends PositionComponent {
  Team({required TeamCoordinator coordinator}) : _coordinator = coordinator;
  final TeamCoordinator _coordinator;

  @override
  void onLoad() {
    final playersHeight = size.y / 2;
    final players =
        Players(
            coordinator: _coordinator.playersInfoCoordinator,
            showActivePlayer: false,
            viewMode: PlayerInfoViewMode.summary,
          )
          ..size = Vector2(size.x, playersHeight)
          ..position = Vector2(0, 0);
    add(players);

    final bases = Bases(coordinator: _coordinator.basesCoordinator)
      ..size = Vector2(size.x, size.y - playersHeight)
      ..position = Vector2(0, players.size.y);
    add(bases);
  }
}
