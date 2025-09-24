import 'package:card_battler/game/coordinators/components/scenes/game_scene_coordinator.dart';
import 'package:card_battler/game/game_variables.dart';
import 'package:card_battler/game/ui/components/card/containers/card_fan.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:card_battler/game/ui/components/enemy/enemies.dart';
import 'package:card_battler/game/ui/components/enemy/enemy_turn.dart';
import 'package:card_battler/game/ui/components/player/player.dart';
import 'package:card_battler/game/ui/components/team/team.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GameScene extends ReactivePositionComponent<GameSceneCoordinator> {
  GameScene(super.coordinator);

  //TODO could we just update the player component and enemy visibility instead of rebuilding everything?
  @override
  void updateDisplay() {
    super.updateDisplay();

    final startY = 0 - size.y / 2;
    final startX = 0 - size.x / 2;
    final enemiesAvailableHeight = size.y / 4;
    final availableHeightForTeam = size.y / 8 * 3;
    final availableHeightForPlayer = availableHeightForTeam;

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

    final player = Player(coordinator.playerCoordinator)
      ..size = Vector2(size.x, availableHeightForPlayer)
      ..position = Vector2(startX, team.position.y + team.size.y);
    add(player);

    final area = CardDragDropArea()
      ..size = Vector2(
        GameVariables.defaultCardSizeWidth * 0.3,
        GameVariables.defaultCardSizeHeight * 0.3,
      )
      ..position = Vector2(
        0 - GameVariables.defaultCardSizeWidth / 2 * 0.3,
        0 - GameVariables.defaultCardSizeHeight / 2 * 0.3,
      )
      ..priority = 1000;

    add(area);
  }
}

class CardDragDropArea extends PositionComponent with DragCallbacks {
  CardDragDropArea();

  @override
  // TODO: implement debugMode
  bool get debugMode => true;

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = const Color.fromARGB(255, 195, 4, 109);
    canvas.drawRect(size.toRect(), paint);
  }
}
