import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/ui/components/player/player_info.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class TeamMate extends PositionComponent {
  TeamMate(PlayerCoordinator coordinator) : _coordinator = coordinator;

  final PlayerCoordinator _coordinator;
  final double margin = 5.0;

  @override
  void onMount() {
    super.onMount();
    removeWhere((component) => true);

    final playerInfo =
        PlayerInfo(_coordinator, isActivePlayer: false)
          ..size = Vector2(size.x, size.y)
          ..position = Vector2(0, 0);

    add(playerInfo);

    // final cardFan = CardFan(
    //   _coordinator.handCardsCoordinator,
    //   mini: true,
    //   fanRadius: 50.0,
    // )..position = Vector2(size.x / 2, playerInfo.size.y);

    // add(cardFan);
  }

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
