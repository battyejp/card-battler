import 'package:card_battler/game/components/team/bases.dart';
import 'package:card_battler/game/components/team/player_stats.dart';
import 'package:card_battler/game/game_constants.dart';
import 'package:card_battler/game/models/team/team_model.dart';
import 'package:flame/components.dart';

class Team extends PositionComponent {
  final TeamModel model;

  Team(this.model);

  @override
  bool get debugMode => true;

  @override
  void onLoad() {
    final statsHeight = size.y * GameConstants.playerStatsHeightFactor;
    double currentY = 0;
    
    for (int i = 0; i < model.playerNames.length; i++) {
      final playerStats = PlayerStats(name: model.playerNames[i])
        ..size = Vector2(size.x, statsHeight)
        ..position = Vector2(0, currentY);
      add(playerStats);
      currentY += statsHeight;
    }

    // Use provided basesModel or create default for backward compatibility
    final bases = Bases(model: model.bases)
      ..size = Vector2(size.x, size.y - currentY)
      ..position = Vector2(0, currentY);
    add(bases);
  }
}