import 'package:flame/components.dart';
import 'package:card_battler/game/models/player_stats_model.dart';
import 'package:card_battler/game/game_constants.dart';

class PlayerStats extends PositionComponent {
  final PlayerStatsModel _model;
  late TextComponent _textComponent;

  PlayerStats({required String name, int maxHealth = GameConstants.defaultMaxHealth}) 
      : _model = PlayerStatsModel(name: name, maxHealth: maxHealth);

  /// Updates current health by [delta], clamps to [0, maxHealth]
  void changeHealth(int delta) {
    _model.changeHealth(delta);
    _updateDisplay();
  }

  void _updateDisplay() {
    if (hasChildren) {
      _textComponent.text = _model.healthDisplay;
    }
  }

  @override
  bool get debugMode => true;

  @override
  void onLoad() {
    super.onLoad();
    _textComponent = TextComponent(
      text: _model.healthDisplay,
      position: Vector2(10, 10),
    );
    add(_textComponent);
  }
}