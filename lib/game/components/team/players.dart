import 'package:card_battler/game/components/team/player_stats.dart';
import 'package:card_battler/game/models/team/player_stats_model.dart';
import 'package:card_battler/game/models/team/players_model.dart';
import 'package:flame/components.dart';

class Players extends PositionComponent {
  final PlayersModel model;
  final bool showActivePlayer;

  Players(this.model, {required this.showActivePlayer});

  @override
  get debugMode => true;

  @override
  void onLoad() {
    late List<PlayerStatsModel> playersToShow = model.players.where((player) => showActivePlayer || !player.isActive).toList();
    double playerHeight = size.y / playersToShow.length;
    double currentY = 0;

    for (int i = 0; i < playersToShow.length; i++) {
      var player = playersToShow[i];

      if (!player.isActive || showActivePlayer) {
        final playerStats = PlayerStats(player)
          ..size = Vector2(size.x, playerHeight)
          ..position = Vector2(0, currentY);
        add(playerStats);
        currentY += playerHeight;
      }
    }
  }
}