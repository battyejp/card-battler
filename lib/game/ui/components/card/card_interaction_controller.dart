import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/services/card/card_interaction_service.dart';
import 'package:card_battler/game/services/card/card_selection_service.dart';
import 'package:card_battler/game/services/card/card_ui_service.dart';
import 'package:card_battler/game/ui/components/card/actionable_card.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';

class CardInteractionController {
  final ActionableCard card;
  CardInteractionService? _cardInteractionService;
  CardSelectionService? _cardSelectionService;
  late CardUIService _cardUIService;

  CardInteractionController(
    this.card, 
    [bool Function()? determineIfButtonEnabled,]
  ) {
    _cardUIService = DefaultCardUIService(businessLogicCheck: determineIfButtonEnabled);
  }
  
  CardInteractionController.withServices(
    this.card, 
    {
      bool Function()? determineIfButtonEnabled,
      CardInteractionService? cardInteractionService,
      CardSelectionService? cardSelectionService,
    }
  ) {
    _cardInteractionService = cardInteractionService;
    _cardSelectionService = cardSelectionService;
    _cardUIService = DefaultCardUIService(businessLogicCheck: determineIfButtonEnabled);
    
    // Listen for selection changes from the service
    _cardSelectionService?.addSelectionListener(_onSelectionChanged);
  }
  
  void _onSelectionChanged(CardModel? selectedCard) {
    // Check if this card should be deselected
    final isCurrentlySelected = selectedCard == card.cardModel;
    
    if (!isCurrentlySelected && _wasSelected && !_isAnimating) {
      // This card was selected but is no longer selected - trigger deselection
      _deselect();
    }
    
    // Update tracking state
    _wasSelected = isCurrentlySelected;
  }
  
  /// Clean up resources (call when controller is no longer needed)
  void dispose() {
    _cardSelectionService?.removeSelectionListener(_onSelectionChanged);
  }

  bool _isAnimating = false;
  bool _wasSelected = false; // Track if this card was selected before the current change
  Vector2 _originalPos = Vector2.zero();
  int _originalPriority = 0;
  final double _animationSpeed = 0.5;
  final double _scaleFactor = 2.5;

  bool get isSelected => _cardSelectionService?.isCardSelected(card.cardModel) ?? false;
  bool get isAnimating => _isAnimating;

  /// Check if any card is currently selected
  bool get isAnyCardSelected => _cardSelectionService?.hasSelection ?? false;

  /// Deselects the currently selected card, if any
  void deselectAny() {
    _cardSelectionService?.deselectCard();
  }

  bool onTapUp(TapUpEvent event) {
    // Only allow selection if no card is selected or this card is already selected
    if (!_isAnimating && (!isAnyCardSelected || isSelected)) {
      if (!isSelected) {
        _selectAtPosition(event.localPosition);
      }
    }
    return true;
  }


  void _selectAtPosition(Vector2 pressPosition) {
    if (isSelected || _isAnimating) return;

    // Deselect any other card and select this one
    _cardSelectionService?.selectCard(card.cardModel);
    _wasSelected = true; // Track that this card is now selected
    _isAnimating = true;

    _originalPriority = card.priority;
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

    targetPosition.x = targetPosition.x - gameSize.x / 2 - card.size.x / 2 * _scaleFactor;
    targetPosition.y = targetPosition.y - gameSize.y / 2 - card.size.y / 2 * _scaleFactor;
    _originalPos = card.position.clone();

    final moveEffect = MoveEffect.to(
      targetPosition,
      EffectController(duration: _animationSpeed),
    );
  
    final scaleEffect = ScaleEffect.to(
      Vector2.all(2.5),
      EffectController(duration: _animationSpeed),
    );

    var buttonDisabled = !_cardUIService.canPlayCard();

    moveEffect.onComplete = () {
      _isAnimating = false;
      card.isButtonVisible = _cardInteractionService?.shouldShowPlayButton() ?? true;
      card.buttonDisabled = buttonDisabled;
    };

    card.add(moveEffect);
    card.add(scaleEffect);
  }

  void _deselect() {
    if (_isAnimating) return;

    _isAnimating = true;
    _wasSelected = false; // Track that this card is no longer selected
    card.isButtonVisible = false;
    card.priority = _originalPriority;

    final moveEffect = MoveEffect.to(
      _originalPos,
      EffectController(duration: _animationSpeed),
    );

    final scaleEffect = ScaleEffect.to(
      Vector2.all(1.0),
      EffectController(duration: _animationSpeed),
    );

    moveEffect.onComplete = () => _isAnimating = false;
    card.add(moveEffect);
    card.add(scaleEffect);
  }
}