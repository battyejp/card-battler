import 'package:card_battler/game/coordinators/components/team/player_stat_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/players_coordinator.dart';
import 'package:card_battler/game/ui/components/team/player_stats.dart';
import 'package:flame/components.dart';

class Players extends PositionComponent {
  final PlayersCoordinator _coordinator;
  final bool _showActivePlayer;

  Players({
    required PlayersCoordinator coordinator,
    required bool showActivePlayer,
  }) : _showActivePlayer = showActivePlayer,
       _coordinator = coordinator;

  @override
  void onLoad() {
    super.onLoad();

    late List<PlayerStatsCoordinator> playersCoordinatorsToShow = _coordinator
        .players
        .where((player) => !player.isActive || _showActivePlayer)
        .toList();

    double playerHeight = size.y / playersCoordinatorsToShow.length;
    double currentY = 0;

    for (int i = 0; i < playersCoordinatorsToShow.length; i++) {
      var playerCoordinator = playersCoordinatorsToShow[i];

      final playerStats = PlayerStats(coordinator: playerCoordinator)
        ..size = Vector2(size.x, playerHeight)
        ..position = Vector2(0, currentY);
      add(playerStats);
      currentY += playerHeight;
    }
  }
}
