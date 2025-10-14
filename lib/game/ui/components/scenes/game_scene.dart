import 'package:card_battler/game/coordinators/components/scenes/game_scene_coordinator.dart';
import 'package:card_battler/game/game_variables.dart';
import 'package:card_battler/game/ui/components/card/card_drop_area.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:card_battler/game/ui/components/enemy/enemies.dart';
import 'package:card_battler/game/ui/components/enemy/enemy_turn.dart';
import 'package:card_battler/game/ui/components/overlay/drag_table_overlay.dart';
import 'package:card_battler/game/ui/components/player/player.dart';
import 'package:card_battler/game/ui/components/team/team.dart';
import 'package:flame/components.dart';

class GameScene extends ReactivePositionComponent<GameSceneCoordinator> {
  GameScene(super.coordinator);

  //TODO could we just update the player component and enemy visibility instead of rebuilding everything?
  @override
  void updateDisplay() {
    super.updateDisplay();

    final startY = 0 - size.y / 2;
    final startX = 0 - size.x / 2;
    final availableHeightForTeam =
        size.y * GameVariables.fractionOfScreenForTeamComponent;
    final enemiesAvailableHeight =
        size.y * GameVariables.fractionOfScreenForEnemyComponent;
    final availableHeightForPlayer =
        size.y * GameVariables.fractionOfScreenForPlayerComponent;

    final enemies = Enemies(coordinator: coordinator.enemiesCoordinator)
      ..size = Vector2(size.x, enemiesAvailableHeight)
      ..position = Vector2(startX, startY);
    add(enemies);

    final enemyTurn = EnemyTurn(coordinator.enemyTurnSceneCoordinator)
      ..size = Vector2(size.x, enemiesAvailableHeight)
      ..position = Vector2(startX, startY);

    add(enemyTurn);

    enemyTurn.isVisible = coordinator.isEnemyTurnSceneVisible;
    enemies.isVisible = !coordinator.isEnemyTurnSceneVisible;

    final team = Team(coordinator.teamCoordinator)
      ..size = Vector2(size.x, availableHeightForTeam)
      ..position = Vector2(startX, enemies.position.y + enemies.size.y);
    add(team);

    // Keep the old CardDragDropArea for intersection checking (but make it invisible)
    const scale = 2.0;
    final area = CardDragDropArea()
      ..size = Vector2(
        GameVariables.defaultCardSizeWidth *
            GameVariables.activePlayerCardFanScale *
            scale,
        GameVariables.defaultCardSizeHeight *
            GameVariables.activePlayerCardFanScale *
            scale,
      )
      ..position = Vector2(
        0 -
            GameVariables.defaultCardSizeWidth /
                2 *
                GameVariables.activePlayerCardFanScale *
                scale,
        team.position.y,
      );

    area.isVisible = false;
    add(area);

    // Add the new dynamic drag overlay
    final dragOverlay = DragTableOverlay(
      tableAreaSize: Vector2(
        GameVariables.defaultCardSizeWidth *
            GameVariables.activePlayerCardFanScale *
            scale,
        GameVariables.defaultCardSizeHeight *
            GameVariables.activePlayerCardFanScale *
            scale,
      ),
      tableAreaPosition: Vector2(
        size.x / 2 - (GameVariables.defaultCardSizeWidth *
            GameVariables.activePlayerCardFanScale *
            scale / 2),
        team.position.y + size.y / 2,
      ),
    )
      ..size = size
      ..position = Vector2(startX, startY)
      ..priority = 999; // High priority to render on top
    
    add(dragOverlay);

    final player = Player(coordinator.playerCoordinator)
      ..size = Vector2(size.x, availableHeightForPlayer)
      ..position = Vector2(startX, team.position.y + team.size.y);
    add(player);
  }
}
