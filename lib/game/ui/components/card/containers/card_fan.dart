import 'dart:math' as math;
import 'dart:ui';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/ui/components/card/card_sprite.dart';
import 'package:card_battler/game/ui/components/card/containers/card_draggable_area.dart';
import 'package:card_battler/game/ui/components/card/interactive_card_sprite.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:flame/components.dart';

class CardFan extends ReactivePositionComponent<CardListCoordinator> {
  CardFan(
    super.coordinator, {
    GamePhaseManager? gamePhaseManager,
    double fanAngle = math.pi / 2, // pi is 180 degrees so pi/2 is 90 degrees
    double fanRadius = 200.0,
    bool mini = false,
    double cardScale = 1.0,
  }) {
    _fanAngle = fanAngle;
    _fanRadius = fanRadius;
    _mini = mini;
    _cardScale = cardScale;
    _gamePhaseManager = gamePhaseManager;
  }

  late final GamePhaseManager? _gamePhaseManager;
  late double _fanAngle;
  late double _fanRadius;
  late bool _mini;
  late double _cardScale;
  final List<CardSprite> _cards = [];

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = const Color.fromARGB(255, 52, 4, 195);
    canvas.drawRect(size.toRect(), paint);
  }

  @override
  void updateDisplay() {
    super.updateDisplay();
    _createCardFan();

    if (!_mini) {
      final draggableArea = CardFanDraggableArea(_gamePhaseManager, this, (card) {
        card.coordinator.handleCardPlayed();;
      })
        ..size = Vector2(size.x, _fanRadius * 2)
        ..priority = 1000
        ..position = Vector2(0, -_fanRadius * 2);
      add(draggableArea);
    }
  }

  void _createCardFan() {
    final cardCount = coordinator.cardCoordinators.length;
    final startAngle = -_fanAngle / 2; // Start from left side of fan
    final angleStep = cardCount > 1
        ? _fanAngle / (cardCount - 1)
        : 0; // Angle between cards

    for (var i = 0; i < cardCount; i++) {
      final cardCoordinator = coordinator.cardCoordinators[i];
      final angle = cardCount == 1 ? 0 : startAngle + (i * angleStep);

      final cardX = _fanRadius * math.sin(angle) + size.x / 2;
      final cardY = -_fanRadius * math.cos(angle);

      final card = _mini
          ? CardSprite(cardCoordinator, _mini)
          : InteractiveCardSprite(cardCoordinator, false);

      card
        ..position = Vector2(cardX, cardY)
        ..scale = Vector2.all(_cardScale)
        ..anchor = Anchor.center
        ..priority = i;

      card.angle = angle * 0.5; // Reduced rotation for subtle effect

      add(card);
      _cards.add(card);
    }
  }
}