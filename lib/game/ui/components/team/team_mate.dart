import 'package:card_battler/game/coordinators/components/team/team_mate_coordinator.dart';
import 'package:card_battler/game/ui/components/card/containers/card_fan.dart';
import 'package:card_battler/game/ui/components/player/player_info.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class TeamMate extends PositionComponent {
  TeamMate(TeamMateCoordinator coordinator) : _coordinator = coordinator;

  final TeamMateCoordinator _coordinator;
  final double margin = 5.0;

  @override
  void onMount() {
    super.onMount();
    removeWhere((component) => true);

    final cardFan = CardFan(
      _coordinator.handCardsCoordinator,
      mini: true,
      fanRadius: 50.0,
    )..position = Vector2(size.x / 2, 50.0 * 2);

    add(cardFan);

    final playerInfo =
        PlayerInfo(
            _coordinator.playerInfoCoordinator,
            isActivePlayer: false,
            gapBetweenNameAndFirstLabel: cardFan.position.y * 0.8,
          )
          ..size = Vector2(size.x, size.y)
          ..position = Vector2(0, 50.0 * 1.5);

    add(playerInfo);
  }

  @override
  void render(Canvas canvas) {
    const size = 75.0;
    final paint = Paint()..color = const Color.fromARGB(143, 0, 0, 0);
    canvas.drawCircle(const Offset(size, size), size, paint);

    final borderPaint = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(const Offset(size, size), size, borderPaint);
  }
}
