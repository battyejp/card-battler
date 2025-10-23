import 'package:card_battler/game/card_battler_game.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/game_variables.dart';
import 'package:card_battler/game/services/card/card_draggable_service.dart';
import 'package:card_battler/game/services/card/card_selection_service.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/ui/components/card/card_drop_area_table.dart';
import 'package:card_battler/game/ui/components/card/interactive_card_sprite.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:flame/components.dart';

class CardHand extends ReactivePositionComponent<CardListCoordinator> {
  CardHand(
    super.coordinator, {
    required CardSelectionService cardSelectionService,
    required CardDropAreaTable cardDropAreaTable,
    GamePhaseManager? gamePhaseManager,
  }) : _cardSelectionService = cardSelectionService,
       _cardDropAreaTable = cardDropAreaTable;

  final CardSelectionService _cardSelectionService;
  final CardDropAreaTable _cardDropAreaTable;
  final totalCardsInRow = GameVariables.maxNumberOfCardsInPlayerHand / 2;

  @override
  void onMount() {
    super.onMount();

    final game = findGame() as CardBattlerGame;
    _cardSelectionService.game = game;
  }

  @override
  void updateDisplay() {
    super.updateDisplay();

    final cardCount = coordinator.cardCoordinators.length;
    final cardSpaceAvailablePreCard = size.x / totalCardsInRow;
    final scaleFactor =
        cardSpaceAvailablePreCard / GameVariables.originalCardSizeWidth;
    final cardScaledHeight = GameVariables.originalCardSizeHeight * scaleFactor;

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

      final cardFanDraggableService = CardDraggableService(
        cardCoordinator.gamePhaseManager,
        _cardDropAreaTable,
        (card) {
          card.coordinator.handleCardPlayed();
        },
      );

      final cardSprite =
          InteractiveCardSprite(
              cardCoordinator,
              _cardSelectionService,
              cardFanDraggableService,
              _cardDropAreaTable,
            )
            ..position = Vector2(
              rowOffset + i * cardSpacing + cardSpacing / 2,
              yPosition,
            )
            ..size = Vector2(
              GameVariables.originalCardSizeWidth * scaleFactor,
              cardScaledHeight,
            )
            ..anchor = Anchor.topCenter;

      add(cardSprite);
    }
  }
}
