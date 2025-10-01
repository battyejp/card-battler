import 'package:card_battler/game/card_battler_game.dart';
import 'package:card_battler/game/services/card/card_fan_draggable_service.dart';
import 'package:card_battler/game/services/card/card_fan_selection_service.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/ui/components/card/card_drop_area.dart';
import 'package:card_battler/game/ui/components/card/interactive_card_sprite.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class CardFanService {
  CardFanService(
    Vector2 size,
    GamePhaseManager gamePhaseManager,
    Function(InteractiveCardSprite) onCardPlayed,
    Function(SpriteComponent) onShowCardAtCenter,
    Function(SpriteComponent) onRemoveCardAtCenter,
  ) : _size = size,
      _gamePhaseManager = gamePhaseManager,
      _onCardPlayed = onCardPlayed,
      _onShowCardAtCenter = onShowCardAtCenter,
      _onRemoveCardAtCenter = onRemoveCardAtCenter {
    _cardSelectionService = CardFanSelectionService(
      _size,
      _onShowCardAtCenter,
      _onRemoveCardAtCenter,
    );
    _cardDraggableService = CardFanDraggableService(
      _cardSelectionService,
      _gamePhaseManager,
      _onCardPlayed,
      _onRemoveCardAtCenter,
    );
  }

  final Vector2 _size;
  final GamePhaseManager _gamePhaseManager;
  final Function(InteractiveCardSprite) _onCardPlayed;
  final Function(SpriteComponent) _onShowCardAtCenter;
  final Function(SpriteComponent) _onRemoveCardAtCenter;

  late CardFanSelectionService _cardSelectionService;
  late CardFanDraggableService _cardDraggableService;

  set game(CardBattlerGame game) {
    _cardSelectionService.game = game;
  }

  set dropArea(CardDragDropArea dropArea) {
    _cardDraggableService.dropArea = dropArea;
  }

  void onTapDown(Vector2 position) {
    _cardSelectionService.findHighestPriorityCardSpriteAndSelect(position);
  }

  void onDragStart(Vector2 position) {
    _cardDraggableService.onDragStart(position);
  }

  void onDragUpdate(DragUpdateEvent event) {
    _cardDraggableService.onDragUpdate(event);
  }

  void onDragEnd() {
    _cardDraggableService.onDragEnd();
  }

  void onTapUp() {
    _cardSelectionService.deselectCard();
  }
}
