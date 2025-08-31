import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';

import 'card.dart';


class CardInteractionController {
  CardInteractionController(this.card);

  final Card card;

  static CardInteractionController? _selectedController;

  bool _isSelected = false;
  bool _isAnimating = false;
  Vector2 originalPos = Vector2.zero();
  double animationSpeed = 0.5;

  bool get isSelected => _isSelected;
  bool get isAnimating => _isAnimating;

  /// Returns the currently selected card controller, if any
  static CardInteractionController? get selectedController => _selectedController;

  /// Deselects the currently selected card, if any
  static void deselectAny() {
    _selectedController?._deselect();
  }

  bool onTapUp(TapUpEvent event) {
    // Only allow selection if no card is selected or this card is already selected
    if (!_isAnimating && (_selectedController == null || _selectedController == this)) {
      if (!_isSelected) {
        _selectAtPosition(event.localPosition);
      }
    }
    return true;
  }


  void _selectAtPosition(Vector2 pressPosition) {
    if (_isSelected || _isAnimating) return;

    if (_selectedController != null && _selectedController != this) {
      _selectedController!._deselect();
    }
    _selectedController = this;

    _isSelected = true;
    _isAnimating = true;

    // // Notify selection manager via callback.
    // card.onSelectionChanged?.call(card);

    card.priority = 99999;

    final gameSize = card.findGame()?.size;
    final screenCenter = Vector2(gameSize!.x / 2, gameSize.y / 2);
    final parent = card.parent;
    Vector2 targetPosition;
    if (parent is PositionComponent) {
      targetPosition = parent.absoluteToLocal(screenCenter);
    } else {
      targetPosition = screenCenter;
    }

    targetPosition.x = targetPosition.x - gameSize.x / 2 - card.size.x / 2 * 2.5;
    targetPosition.y = targetPosition.y - gameSize.y / 2 - card.size.y / 2 * 2.5;
    originalPos = card.position.clone();

    final moveEffect = MoveEffect.to(
      targetPosition,
      EffectController(duration: animationSpeed),
    );
  
    final scaleEffect = ScaleEffect.to(
      Vector2.all(2.5),
      EffectController(duration: animationSpeed),
    );

    moveEffect.onComplete = () => _isAnimating = false;

    card.add(moveEffect);
    card.add(scaleEffect);
  }

  void _deselect() {
    if (!_isSelected || _isAnimating) return;

    _isSelected = false;
    _isAnimating = true;
    _selectedController = null;

    final moveEffect = MoveEffect.to(
      originalPos,
      EffectController(duration: animationSpeed),
    );

    final scaleEffect = ScaleEffect.to(
      Vector2.all(1.0),
      EffectController(duration: animationSpeed),
    );

    moveEffect.onComplete = () => _isAnimating = false;
    card.add(moveEffect);
    card.add(scaleEffect);
  }
}