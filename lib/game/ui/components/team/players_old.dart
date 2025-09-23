import 'package:card_battler/game/coordinators/components/team/players_info_coordinator.dart';
import 'package:card_battler/game/ui/components/player/player_info_old.dart';
import 'package:flame/components.dart';

class Players extends PositionComponent {
  Players({
    required PlayersInfoCoordinator coordinator,
    required bool showActivePlayer,
    required PlayerInfoViewMode viewMode,
  }) : _showActivePlayer = showActivePlayer,
       _coordinator = coordinator,
       _viewMode = viewMode;

  final PlayersInfoCoordinator _coordinator;
  final bool _showActivePlayer;
  final PlayerInfoViewMode _viewMode;

  @override
  void onLoad() {
    super.onLoad();

    late final playersCoordinatorsToShow = _coordinator.players
        .where((player) => !player.isActive || _showActivePlayer)
        .toList();

    final playerHeight = size.y / playersCoordinatorsToShow.length;
    double currentY = 0;

    for (var i = 0; i < playersCoordinatorsToShow.length; i++) {
      final playerCoordinator = playersCoordinatorsToShow[i];

      final playerInfo = PlayerInfoOld(playerCoordinator, viewMode: _viewMode)
        ..size = Vector2(size.x, playerHeight)
        ..position = Vector2(0, currentY);
      add(playerInfo);
      currentY += playerHeight;
    }
  }
}
