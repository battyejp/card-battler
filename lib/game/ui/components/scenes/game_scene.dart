import 'package:card_battler/game/coordinators/components/scenes/game_scene_coordinator.dart';
import 'package:card_battler/game/game_variables.dart';
import 'package:card_battler/game/services/card/card_selection_service.dart';
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

  late CardDropAreaTable dropAreaTable;

  //TODO could we just update the player component and enemy visibility instead of rebuilding everything?
  @override
  void updateDisplay() {
    super.updateDisplay();

    final startY = -size.y / 2;
    final startX = -size.x / 2;
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

    final cardSelectionService = CardSelectionService();
    final darkeningOverlay =
        DarkeningOverlay(cardSelectionService: cardSelectionService)
          ..size = size
          ..position = Vector2(startX, startY)
          ..priority = GameVariables.darkenOverlayPriority;
    darkeningOverlay.isVisible = false;
    cardSelectionService.darkeningOverlay = darkeningOverlay;

    // Create unified drop area table
    final tableWidth = size.x * GameVariables.dropAreaWidthFractionOfScreen;
    final tableHeight = size.y * GameVariables.dropAreaHeightFractionOfScreen;
    final dropAreaY =
        team.position.y + team.size.y * GameVariables.dropAreaHeightRatio;

    dropAreaTable = CardDropAreaTable()
      ..size = Vector2(tableWidth, tableHeight)
      ..position = Vector2(
        (size.x - tableWidth) / 2 + startX, // Center horizontally
        dropAreaY,
      )
      ..priority = GameVariables
          .dropAreaTablePriority; // Same as player to appear above darkening overlay
    dropAreaTable.isVisible = false;

    final player =
        Player(
            coordinator.playerCoordinator,
            cardSelectionService,
            dropAreaTable,
          )
          ..size = Vector2(size.x, availableHeightForPlayer)
          ..position = Vector2(startX, team.position.y + team.size.y);

    add(player);
    add(darkeningOverlay);
    add(dropAreaTable);
  }
}
