import 'package:card_battler/game/services/card/cards_selection_manager_service.dart';
import 'package:card_battler/game/services/game_state/game_phase_manager.dart';
import 'package:card_battler/game/ui/components/card/actionable_card.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';

class CardSelectionService {
  final ActionableCard _card;
  final CardsSelectionManagerService _cardsSelectionManagerService;
  final GamePhaseManager _gamePhaseManager;

  CardSelectionService({
    required ActionableCard card,
    required CardsSelectionManagerService cardsSelectionManagerService,
    required GamePhaseManager gamePhaseManager,
  }) : _card = card,
       _cardsSelectionManagerService = cardsSelectionManagerService,
       _gamePhaseManager = gamePhaseManager;

  final double _animationSpeed = 0.5;
  final double _scaleFactor = 2.5;

  bool _isAnimating = false;
  int _originalPriority = 0;
  Vector2 _originalPos = Vector2.zero();

  bool get isAnyCardSelected => _cardsSelectionManagerService.hasSelection;

  bool onSelected(TapUpEvent event) {
    if (_isAnimating || isAnyCardSelected) return false;

    _selectAtPosition(event.localPosition);
    return true;
  }

  void onDeselect() {
    _deselect();
  }

  void _selectAtPosition(Vector2 pressPosition) {
    _cardsSelectionManagerService.selectCard(_card.coordinator);
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
      //TODO do these checks needs game phase and shop affordability
      _card.isActionButtonVisible =
          _gamePhaseManager.currentPhase == GamePhase.playerTurn;
      //_card.buttonDisabled = false; //buttonDisabled;
    };

    _card.add(moveEffect);
    _card.add(scaleEffect);
  }

  void _deselect() {
    if (_isAnimating) return;

    _cardsSelectionManagerService.deselectCard();

    _isAnimating = true;

    _card.isActionButtonVisible = false;
    _card.priority = _originalPriority;

    final moveEffect = MoveEffect.to(
      _originalPos,
      EffectController(duration: _animationSpeed),
    );

    final scaleEffect = ScaleEffect.to(
      Vector2.all(1.0),
      EffectController(duration: _animationSpeed),
    );

    moveEffect.onComplete = () => _isAnimating = false;
    _card.add(moveEffect);
    _card.add(scaleEffect);
  }
}
