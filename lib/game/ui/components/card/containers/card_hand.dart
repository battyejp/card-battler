import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/ui/components/card/card_sprite.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class CardHand extends ReactivePositionComponent<CardListCoordinator> {
  CardHand(super.coordinator, {GamePhaseManager? gamePhaseManager})
    : _gamePhaseManager = gamePhaseManager;

  final GamePhaseManager? _gamePhaseManager;
  final cardWidth = 864.0;
  final cardHeight = 1184.0;
  final totalCardsInRow = 5;

  @override
  void updateDisplay() {
    super.updateDisplay();

    final cardCount = coordinator.cardCoordinators.length;
    final cardSpaceAvailablePreCard = size.x / totalCardsInRow;
    final scaleFactor = cardSpaceAvailablePreCard / cardWidth;
    final cardScaledHeight = cardHeight * scaleFactor;

    if (cardCount >= 5) {
      _layoutTwoRows(
        cardCount,
        cardSpaceAvailablePreCard,
        scaleFactor,
        cardScaledHeight,
      );
    } else {
      _layoutSingleRow(
        cardCount,
        cardSpaceAvailablePreCard,
        scaleFactor,
        cardScaledHeight,
      );
    }
  }

  void _layoutTwoRows(
    int cardCount,
    double cardSpacing,
    double scaleFactor,
    double cardScaledHeight,
  ) {
    final topRowCount = (cardCount / 2).ceil();
    final bottomRowCount = cardCount - topRowCount;

    _addCardRow(
      0,
      topRowCount,
      cardSpacing,
      scaleFactor,
      cardScaledHeight,
      yPosition: 0,
    );
    _addCardRow(
      topRowCount,
      bottomRowCount,
      cardSpacing,
      scaleFactor,
      cardScaledHeight,
      yPosition: cardScaledHeight,
    );
  }

  void _layoutSingleRow(
    int cardCount,
    double cardSpacing,
    double scaleFactor,
    double cardScaledHeight,
  ) {
    _addCardRow(
      0,
      cardCount,
      cardSpacing,
      scaleFactor,
      cardScaledHeight,
      yPosition: cardScaledHeight / 2,
    );
  }

  void _addCardRow(
    int startIndex,
    int count,
    double cardSpacing,
    double scaleFactor,
    double cardScaledHeight, {
    required double yPosition,
  }) {
    final rowOffset = (totalCardsInRow - count) * cardSpacing / 2;

    for (var i = 0; i < count; i++) {
      final cardCoordinator = coordinator.cardCoordinators[startIndex + i];
      final cardSprite = CardSprite(cardCoordinator, false)
        ..position = Vector2(
          rowOffset + i * cardSpacing + cardSpacing / 2,
          yPosition,
        )
        ..size = Vector2(cardWidth * scaleFactor, cardScaledHeight)
        ..anchor = Anchor.topCenter;

      add(cardSprite);
    }
  }
}
