import 'package:card_battler/game/ui/components/card/actionable_card.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/foundation.dart';

class CardAnimationService {
  CardAnimationService({
    required ActionableCard card,
  }) : _card = card;

  final ActionableCard _card;
  final double _animationSpeed = 0.5;
  final double _scaleFactor = 2.5;

  bool _isAnimating = false;
  int _originalPriority = 0;
  Vector2 _originalPos = Vector2.zero();

  bool get isAnimating => _isAnimating;

  void animateToSelection(Vector2 pressPosition, VoidCallback onComplete) {
    _isAnimating = true;
    _originalPriority = _card.priority;
    _card.priority = 99999;

    final gameSize = _card.findGame()?.size;
    final screenCenter = Vector2(gameSize!.x / 2, gameSize.y / 2);
    final parent = _card.parent;
    Vector2 targetPosition;
    if (parent is PositionComponent) {
      targetPosition = parent.absoluteToLocal(screenCenter);
    } else {
      targetPosition = screenCenter;
    }

    targetPosition.x =
        targetPosition.x - gameSize.x / 2 - _card.size.x / 2 * _scaleFactor;
    targetPosition.y =
        targetPosition.y - gameSize.y / 2 - _card.size.y / 2 * _scaleFactor;
    _originalPos = _card.position.clone();

    final moveEffect = MoveEffect.to(
      targetPosition,
      EffectController(duration: _animationSpeed),
    );

    final scaleEffect = ScaleEffect.to(
      Vector2.all(2.5),
      EffectController(duration: _animationSpeed),
    );

    moveEffect.onComplete = () {
      _isAnimating = false;
      onComplete();
    };

    _card.add(moveEffect);
    _card.add(scaleEffect);
  }

  void animateToDeselection(VoidCallback onComplete) {
    if (_isAnimating) {
      return;
    }

    _isAnimating = true;
    _card.priority = _originalPriority;

    final moveEffect = MoveEffect.to(
      _originalPos,
      EffectController(duration: _animationSpeed),
    );

    final scaleEffect = ScaleEffect.to(
      Vector2.all(1.0),
      EffectController(duration: _animationSpeed),
    );

    moveEffect.onComplete = () {
      _isAnimating = false;
      onComplete();
    };

    _card.add(moveEffect);
    _card.add(scaleEffect);
  }
}