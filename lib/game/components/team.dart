import 'package:card_battler/game/components/base.dart';
import 'package:card_battler/game/components/player_stats.dart';
import 'package:flame/components.dart';

class Team extends PositionComponent {
  static const playerStatsHeightFactor = 0.15;

  @override
  bool get debugMode => true;

  @override
  void onLoad() {
    final statsCount = 3;
    final statsHeight = size.y * playerStatsHeightFactor;
    double currentY = 0;
    for (int i = 0; i < statsCount; i++) {
      final playerStats = PlayerStats()
        ..size = Vector2(size.x, statsHeight)
        ..position = Vector2(0, currentY);
      add(playerStats);
      currentY += statsHeight;
    }

    final base = Base()
      ..size = Vector2(size.x, size.y - currentY)
      ..position = Vector2(0, currentY);
    add(base);
  }
}