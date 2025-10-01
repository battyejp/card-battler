import 'dart:ui';

import 'package:card_battler/game/card_battler_game.dart';
import 'package:card_battler/game/services/card/card_fan_input_handler.dart';
import 'package:card_battler/game/services/card/card_fan_service.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/ui/components/card/containers/card_fan.dart';
import 'package:card_battler/game/ui/components/card/interactive_card_sprite.dart';
import 'package:card_battler/game/ui/rendering/card_fan_visualization_renderer.dart';
import 'package:card_battler/game/utils/drop_area_finder.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

/// Coordinates input handling for the card fan draggable area.
/// 
/// This class acts as a thin coordinator that:
/// - Receives input events from Flame's event system
/// - Delegates input handling to CardFanInputHandler
/// - Delegates rendering to CardFanVisualizationRenderer
/// - Uses DropAreaFinder to locate the drop area in the component tree
/// 
/// Responsibilities are now separated:
/// - Input handling -> CardFanInputHandler
/// - Drop area finding -> DropAreaFinder
/// - Visualization rendering -> CardFanVisualizationRenderer
/// - Card selection/dragging logic -> CardFanService (and its sub-services)
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
    _inputHandler = CardFanInputHandler(_cardFanService);
    _visualizationRenderer = CardFanVisualizationRenderer();
  }

  late CardFanService _cardFanService;
  late CardFanInputHandler _inputHandler;
  late CardFanVisualizationRenderer _visualizationRenderer;
  final CardFan _cardFan;

  late GamePhaseManager? _gamePhaseManager;

  @override
  void onMount() {
    super.onMount();

    final game = findGame() as CardBattlerGame;
    _cardFanService.game = game;
    
    // Use DropAreaFinder utility to locate the drop area
    final dropArea = DropAreaFinder.findDropArea(this);
    if (dropArea != null) {
      _cardFanService.dropArea = dropArea;
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    _inputHandler.onTapDown(event.canvasPosition);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    _inputHandler.onDragStart(event.canvasPosition);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    _inputHandler.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _inputHandler.onDragEnd();
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    _inputHandler.onTapUp();
  }

  @override
  void render(Canvas canvas) {
    _visualizationRenderer.render(canvas, size.toRect());
  }
}
