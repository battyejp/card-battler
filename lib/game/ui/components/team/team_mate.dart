import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/game_variables.dart';
import 'package:card_battler/game/ui/components/common/icon_stat.dart';
import 'package:card_battler/game/ui/components/shared/icon_stat_component.dart';
import 'package:card_battler/game/ui/icon_manager.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class TeamMate extends PositionComponent {
  TeamMate(PlayerCoordinator coordinator) : _coordinator = coordinator;

  final PlayerCoordinator _coordinator;
  final double margin = 5.0;

  @override
  void onMount() {
    super.onMount();

    final nameLabel = TextComponent(
      text: _coordinator.name,
      position: Vector2.zero(),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: GameVariables.teamMateNameFontSize,
          color: Colors.white,
        ),
      ),
    );
    add(nameLabel);
    //addCardHandAbilities(nameLabel, 'name');

    final secondLinePositionY = nameLabel.height + margin;
    final iconWidth = GameVariables.teamMateIconSize + margin;

    final healthIcon = IconStatComponent(
      _coordinator.healthStatCoordinator,
      IconManager.heart(),
      GameVariables.teamMateIconSize,
    )..position = Vector2(0, secondLinePositionY);
    add(healthIcon);

    final creditsIcon = IconStatComponent(
      _coordinator.creditsStatCoordinator,
      IconManager.rupee(),
      GameVariables.teamMateIconSize,
    )..position = Vector2(iconWidth, secondLinePositionY);
    add(creditsIcon);

    final attackIcon = IconStatComponent(
      _coordinator.attackStatCoordinator,
      IconManager.target(),
      GameVariables.teamMateIconSize,
    )..position = Vector2(iconWidth * 2, secondLinePositionY);
    add(attackIcon);

    final iconStat =
        IconStat(
            IconManager.cardPile(),
            GameVariables.teamMateIconSize,
            _coordinator.handCardsCoordinator.cardCoordinators.length,
          )
          ..size = Vector2.all(GameVariables.teamMateIconSize)
          ..position = Vector2(iconWidth * 3, secondLinePositionY);
    add(iconStat);
  }

  // void addCardHandAbilities(TextComponent label, String key) {
  //   if (key == 'name' && coordinator.hasAMaxDamageCard()) {
  //     add(
  //       SvgComponent(svg: IconManager.shield())
  //         ..position = Vector2(
  //           label.position.x + label.size.x + 10,
  //           label.position.y,
  //         )
  //         ..size = Vector2.all(16),
  //     );
  //   }
  // }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = const Color.fromARGB(143, 0, 0, 0);
    canvas.drawRect(size.toRect(), paint);

    final borderPaint = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRect(size.toRect(), borderPaint);
  }
}
