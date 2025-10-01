import 'package:card_battler/game/services/card/card_fan_service.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

/// Handles all input events (tap and drag) for the card fan draggable area.
/// This class is responsible only for receiving input events and delegating
/// to the appropriate service methods.
class CardFanInputHandler {
  CardFanInputHandler(this._cardFanService);

  final CardFanService _cardFanService;

  void onTapDown(Vector2 position) {
    _cardFanService.onTapDown(position);
  }

  void onTapUp() {
    _cardFanService.onTapUp();
  }

  void onDragStart(Vector2 position) {
    _cardFanService.onDragStart(position);
  }

  void onDragUpdate(DragUpdateEvent event) {
    _cardFanService.onDragUpdate(event);
  }

  void onDragEnd() {
    _cardFanService.onDragEnd();
  }
}
