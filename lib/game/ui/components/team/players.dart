import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/players_coordinator.dart';
import 'package:card_battler/game/ui/components/player/player_info.dart';
import 'package:flame/components.dart';

class Players extends PositionComponent {
  final PlayersCoordinator _coordinator;
  final bool _showActivePlayer;
  final PlayerInfoViewMode _viewMode;

  Players({
    required PlayersCoordinator coordinator,
    required bool showActivePlayer,
    required PlayerInfoViewMode viewMode,
  }) : _showActivePlayer = showActivePlayer,
       _coordinator = coordinator,
       _viewMode = viewMode;

  @override
  void onLoad() {
    super.onLoad();

    late List<PlayerInfoCoordinator> playersCoordinatorsToShow = _coordinator
        .players
        .where((player) => !player.isActive || _showActivePlayer)
        .toList();

    double playerHeight = size.y / playersCoordinatorsToShow.length;
    double currentY = 0;

    for (int i = 0; i < playersCoordinatorsToShow.length; i++) {
      var playerCoordinator = playersCoordinatorsToShow[i];

      final playerInfo = PlayerInfo(coordinator: playerCoordinator, viewMode: _viewMode)
        ..size = Vector2(size.x, playerHeight)
        ..position = Vector2(0, currentY);
      add(playerInfo);
      currentY += playerHeight;
    }
  }
}
