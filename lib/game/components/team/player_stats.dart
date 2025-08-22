import 'package:card_battler/game/models/team/player_stats_model.dart';
import 'package:flame/components.dart';

class PlayerStats extends PositionComponent {
  final PlayerStatsModel _model;
  late TextComponent _textComponent;

  PlayerStats({required PlayerStatsModel model})
      : _model = model;

  /// Updates current health by [delta], clamps to [0, maxHealth]
  void changeHealth(int delta) {
    _model.health.changeHealth(delta);
    _updateDisplay();
  }

  void _updateDisplay() {
    if (hasChildren) {
      _textComponent.text = _model.display;
    }
  }

  @override
  bool get debugMode => true;

  @override
  void onLoad() {
    super.onLoad();
    _textComponent = TextComponent(
      text: _model.display,
      position: Vector2(10, 10),
    );
    add(_textComponent);
  }
}