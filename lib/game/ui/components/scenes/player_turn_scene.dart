import 'package:card_battler/game/coordinators/components/scenes/player_turn_scene_coordinator.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:card_battler/game/ui/components/enemy/enemies.dart';
import 'package:card_battler/game/ui/components/player/player.dart';
import 'package:card_battler/game/ui/components/team/team.dart';
import 'package:flame/components.dart';

class PlayerTurnScene
    extends ReactivePositionComponent<PlayerTurnSceneCoordinator> {
  PlayerTurnScene(super.coordinator, {required Vector2 size}) : _size = size;

  final Vector2 _size;

  //TODO could we just update the player component
  @override
  void updateDisplay() {
    super.updateDisplay();

    final startY = 0 - _size.y / 2;
    final startX = 0 - _size.x / 2;
    final enemiesAvailableHeight = _size.y / 4;
    final availableHeightForTeam = _size.y / 8 * 3;
    final availableHeightForPlayer = availableHeightForTeam;

    final enemies = Enemies(coordinator: coordinator.enemiesCoordinator)
      ..size = Vector2(_size.x, enemiesAvailableHeight)
      ..position = Vector2(startX, startY);
    add(enemies);

    final team = Team()
      ..size = Vector2(_size.x, availableHeightForTeam)
      ..position = Vector2(startX, enemies.position.y + enemies.size.y);
    add(team);

    final player = Player()
      ..size = Vector2(_size.x, availableHeightForPlayer)
      ..position = Vector2(startX, team.position.y + team.size.y);
    add(player);
  }
}
