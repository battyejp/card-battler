import 'package:card_battler/game/card_battler_game.dart';
import 'package:card_battler/game/models/shared/play_effects_model.dart';
import 'package:card_battler/game/services/card/card_fan_draggable_service.dart';
import 'package:card_battler/game/services/card/card_fan_selection_service.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/ui/components/card/card_drop_area_table.dart';
import 'package:card_battler/game/ui/components/card/containers/card_fan.dart';
import 'package:card_battler/game/ui/components/card/interactive_card_sprite.dart';
import 'package:card_battler/game/ui/components/common/darkening_overlay.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class CardFanDraggableArea extends PositionComponent
    with DragCallbacks, TapCallbacks {
  CardFanDraggableArea(
    GamePhaseManager? gamePhaseManager,
    CardFan parent,
    Function(InteractiveCardSprite) onCardPlayed,
  ) : _cardFan = parent,
      _gamePhaseManager = gamePhaseManager,
      _onCardPlayed = onCardPlayed {
    // Initialize services directly
    _cardSelectionService = CardFanSelectionService(_cardFan.size, add, remove);
    _cardDraggableService = CardFanDraggableService(
      _cardSelectionService,
      _gamePhaseManager!,
      _onCardPlayed,
      remove,
    );
  }

  late CardFanSelectionService _cardSelectionService;
  late CardFanDraggableService _cardDraggableService;
  final CardFan _cardFan;

  final GamePhaseManager? _gamePhaseManager;
  final Function(InteractiveCardSprite) _onCardPlayed;

  @override
  void onMount() {
    super.onMount();

    final game = findGame() as CardBattlerGame;
    _cardSelectionService.game = game;
    _cardDraggableService.dropArea = _findDropAreaTable()!;

    // Wire darkening overlay to both services
    final overlay = _findDarkeningOverlay();
    _cardDraggableService.darkeningOverlay = overlay;
    _cardSelectionService.darkeningOverlay = overlay;
  }

  CardDropAreaTable? _findDropAreaTable() {
    final cardFan = parent;
    if (cardFan != null) {
      final player = cardFan.parent;
      if (player != null) {
        final gameScene = player.parent;
        if (gameScene != null) {
          final dropArea = gameScene.children
              .whereType<CardDropAreaTable>()
              .firstOrNull;
          return dropArea;
        }
      }
    }
    return null;
  }

  DarkeningOverlay? _findDarkeningOverlay() {
    final cardFan = parent;
    if (cardFan != null) {
      final player = cardFan.parent;
      if (player != null) {
        final gameScene = player.parent;
        if (gameScene != null) {
          final overlay = gameScene.children
              .whereType<DarkeningOverlay>()
              .firstOrNull;
          return overlay;
        }
      }
    }
    return null;
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    _cardSelectionService.findHighestPriorityCardSpriteAndSelect(
      event.canvasPosition,
    );
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);

    // Configure the table zones based on the selected card's operator
    if (_cardSelectionService.selectedCard != null) {
      final operator =
          _cardSelectionService.selectedCard!.coordinator.playEffects.operator;

      final table = _findDropAreaTable();
      if (table != null) {
        // Set number of zones based on operator
        if (operator == EffectsOperator.or) {
          table.setNumberOfZones(2); // Two zones for "Or" operator
        } else {
          table.setNumberOfZones(1); // Single zone for "And" operator
        }
      }
    }

    _cardDraggableService.onDragStart(event.canvasPosition);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    _cardDraggableService.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _cardDraggableService.onDragEnd();
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    _cardSelectionService.deselectCard();
  }

  // @override
  // void render(Canvas canvas) {
  //   final paint = Paint()
  //     ..color = const Color.fromARGB(77, 195, 4, 4); // Red with 0.3 opacity
  //   canvas.drawRect(size.toRect(), paint);
  // }
}
