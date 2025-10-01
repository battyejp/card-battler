import 'package:card_battler/game/card_battler_game.dart';
import 'package:card_battler/game/services/card/card_fan_service.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/ui/components/card/card_drop_area.dart';
import 'package:card_battler/game/ui/components/card/containers/card_fan.dart';
import 'package:card_battler/game/ui/components/card/interactive_card_sprite.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class CardFanDraggableArea extends PositionComponent
    with DragCallbacks, TapCallbacks {
  CardFanDraggableArea(
    GamePhaseManager? gamePhaseManager,
    CardFan parent,
    Function(InteractiveCardSprite) onCardPlayed,
  ) : _cardFan = parent {
    _gamePhaseManager = gamePhaseManager;
    _cardFanService = CardFanService(
      _cardFan.size,
      _gamePhaseManager!,
      onCardPlayed,
      add,
      remove,
    );
  }

  late CardFanService _cardFanService;
  final CardFan _cardFan;

  late GamePhaseManager? _gamePhaseManager;

  @override
  void onMount() {
    super.onMount();

    final game = findGame() as CardBattlerGame;
    _cardFanService.game = game;
    _cardFanService.dropArea = _findCardDragDropArea()!;
  }

  CardDragDropArea? _findCardDragDropArea() {
    final cardFan = parent;
    if (cardFan != null) {
      final player = cardFan.parent;
      if (player != null) {
        final gameScene = player.parent;
        if (gameScene != null) {
          final dropArea = gameScene.children
              .whereType<CardDragDropArea>()
              .firstOrNull;
          return dropArea;
        }
      }
    }
    return null;
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    _cardFanService.onTapDown(event.canvasPosition);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    _cardFanService.onDragStart(event.canvasPosition);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    _cardFanService.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _cardFanService.onDragEnd();
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    _cardFanService.onTapUp();
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = const Color.fromARGB(77, 195, 4, 4); // Red with 0.3 opacity
    canvas.drawRect(size.toRect(), paint);
  }
}
