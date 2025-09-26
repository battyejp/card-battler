import 'package:card_battler/game/coordinators/components/scenes/game_scene_coordinator.dart';
import 'package:card_battler/game/game_variables.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:card_battler/game/ui/components/enemy/enemies.dart';
import 'package:card_battler/game/ui/components/enemy/enemy_turn.dart';
import 'package:card_battler/game/ui/components/player/player.dart';
import 'package:card_battler/game/ui/components/shared/turn_button_component.dart';
import 'package:card_battler/game/ui/components/team/team.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
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

    //TODO get the scale factor from card fan or hardcode it somewhere else
    final area = CardDragDropArea()
      ..size = Vector2(
        GameVariables.defaultCardSizeWidth * 0.3 * 1.8,
        GameVariables.defaultCardSizeHeight * 0.3 * 1.8,
      )
      ..position = Vector2(
        0 - GameVariables.defaultCardSizeWidth / 2 * 0.3 * 1.8,
        team.position.y,
      );

    area.isVisible = false;
    add(area);

    final player = Player(coordinator.playerCoordinator)
      ..size = Vector2(size.x, availableHeightForPlayer)
      ..position = Vector2(startX, team.position.y + team.size.y);
    add(player);

    final turnBtn = TurnButtonComponent(coordinator.turnButtonComponentCoordinator)
      ..priority = 10
      ..size = Vector2(200, 50)
      ..position = Vector2(0, ((size.y / 2) * -1) + (size.y * 0.05));
    add(turnBtn);
  }
}

//TODO move to own file
class CardDragDropArea extends PositionComponent
    with DragCallbacks, HasVisibility {
  CardDragDropArea();

  bool isHighlighted = false;

  @override
  void onMount() {
    super.onMount();

    final textComponent = TextComponent(
      text: 'Play Card Here',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    textComponent.position = Vector2(size.x / 2, size.y / 2);
    textComponent.anchor = Anchor.center;

    add(textComponent);
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = isHighlighted
          ? const Color.fromARGB(255, 195, 4, 109)
          : const Color.fromARGB(255, 3, 190, 47);
    canvas.drawRect(size.toRect(), paint);
  }
}
