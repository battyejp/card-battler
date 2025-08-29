import 'package:card_battler/game/components/shared/health.dart';
import 'package:card_battler/game/models/team/player_stats_model.dart';
import 'package:flame/components.dart';

class PlayerStats extends PositionComponent {
  final PlayerStatsModel _model;

  PlayerStats({required PlayerStatsModel model})
      : _model = model;

  @override
  bool get debugMode => true;

  @override
  void onLoad() {
    super.onLoad();
    var textComponent = TextComponent(
      text: _model.name,
      position: Vector2(0, size.y / 2),
      anchor: Anchor.centerLeft,
    );

    add(textComponent);

    var healthComponent = Health(_model.health)
      ..anchor = Anchor.centerLeft
      ..position = Vector2(size.x / 2, size.y / 2);

    add(healthComponent);
  }
}