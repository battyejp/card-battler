import 'package:card_battler/game/components/bases.dart';
import 'package:card_battler/game/components/player_stats.dart';
import 'package:card_battler/game/game_constants.dart';
import 'package:flame/components.dart';

class Team extends PositionComponent {
  final List<String> names;

  Team({required this.names});

  @override
  bool get debugMode => true;

  @override
  void onLoad() {
    final statsCount = names.length;
    final statsHeight = size.y * GameConstants.playerStatsHeightFactor;
    double currentY = 0;
    for (int i = 0; i < statsCount; i++) {
      final playerStats = PlayerStats(name: names[i])
        ..size = Vector2(size.x, statsHeight)
        ..position = Vector2(0, currentY);
      add(playerStats);
      currentY += statsHeight;
    }

    final base = Bases()
      ..size = Vector2(size.x, size.y - currentY)
      ..position = Vector2(0, currentY);
    add(base);
  }
}