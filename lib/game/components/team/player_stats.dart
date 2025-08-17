import 'package:flame/components.dart';
import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:card_battler/game/game_constants.dart';

class PlayerStats extends PositionComponent {
  final String name;
  final HealthModel _health;
  late TextComponent _textComponent;

  PlayerStats({required this.name, int maxHealth = GameConstants.defaultPlayerMaxHealth}) 
      : _health = HealthModel(maxHealth: maxHealth);

  /// Updates current health by [delta], clamps to [0, maxHealth]
  void changeHealth(int delta) {
    _health.changeHealth(delta);
    _updateDisplay();
  }

  void _updateDisplay() {
    if (hasChildren) {
      _textComponent.text = '$name: ${_health.healthDisplay}';
    }
  }

  @override
  bool get debugMode => true;

  @override
  void onLoad() {
    super.onLoad();
    _textComponent = TextComponent(
      text: '$name: ${_health.healthDisplay}',
      position: Vector2(10, 10),
    );
    add(_textComponent);
  }
}