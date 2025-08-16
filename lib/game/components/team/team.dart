import 'package:card_battler/game/components/team/bases.dart';
import 'package:card_battler/game/components/team/player_stats.dart';
import 'package:card_battler/game/models/team/bases_model.dart';
import 'package:card_battler/game/game_constants.dart';
import 'package:flame/components.dart';

class Team extends PositionComponent {
  final List<String> names;
  final BasesModel model;

  Team(this.model, this.names); //TODO move names to model

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

    // Use provided basesModel or create default for backward compatibility
    final bases = Bases(model: model)
      ..size = Vector2(size.x, size.y - currentY)
      ..position = Vector2(0, currentY);
    add(bases);
  }
}