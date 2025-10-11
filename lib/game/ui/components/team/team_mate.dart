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

    final playerName = TextComponent(
      text: _coordinator.playerInfoCoordinator.name,
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, 10),
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
    add(playerName);

    final cardFan = CardFan(
      _coordinator.handCardsCoordinator,
      mini: true,
      fanRadius: 50.0,
    )..position = Vector2(size.x / 2, 110);

    add(cardFan);

    final playerInfo =
        PlayerInfo(
            _coordinator.playerInfoCoordinator,
            isActivePlayer: false,
            gapBetweenNameAndFirstLabel: cardFan.position.y * 0.8,
          )
          ..size = Vector2(size.x, size.y)
          ..position = Vector2(0, 0);

    add(playerInfo);
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = const Color.fromARGB(138, 0, 0, 0);
    canvas.drawRect(size.toRect(), paint);
  }
}
