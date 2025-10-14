import 'package:card_battler/game/coordinators/components/scenes/game_scene_coordinator.dart';
import 'package:card_battler/game/game_variables.dart';
import 'package:card_battler/game/ui/components/card/card_drop_area_table.dart';
import 'package:card_battler/game/ui/components/common/darkening_overlay.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:card_battler/game/ui/components/enemy/enemies.dart';
import 'package:card_battler/game/ui/components/enemy/enemy_turn.dart';
import 'package:card_battler/game/ui/components/player/player.dart';
import 'package:card_battler/game/ui/components/team/team.dart';
import 'package:flame/components.dart';

class GameScene extends ReactivePositionComponent<GameSceneCoordinator> {
  GameScene(super.coordinator);

  late DarkeningOverlay darkeningOverlay;
  late CardDropAreaTable dropAreaTable;

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

    // Add darkening overlay (should be above most components but below dragged card)
    darkeningOverlay = DarkeningOverlay()
      ..size = size
      ..position = Vector2(startX, startY)
      ..priority = 50;
    darkeningOverlay.isVisible = false;
    add(darkeningOverlay);

    // Create unified drop area table
    final tableWidth = size.x * 0.9; // 80% of screen width
    final tableHeight = size.y * 0.3; // 15% of screen height
    final dropAreaY = team.position.y + team.size.y * 0.5;

    dropAreaTable = CardDropAreaTable()
      ..size = Vector2(tableWidth, tableHeight)
      ..position = Vector2(
        (size.x - tableWidth) / 2 + startX, // Center horizontally
        dropAreaY,
      )
      ..priority = 100; // Same as player to appear above darkening overlay
    dropAreaTable.isVisible = false;
    add(dropAreaTable);

    final player = Player(coordinator.playerCoordinator)
      ..size = Vector2(size.x, availableHeightForPlayer)
      ..position = Vector2(startX, team.position.y + team.size.y)
      ..priority = 100;
    add(player);
  }
}
