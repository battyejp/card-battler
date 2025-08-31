import 'dart:ui';

import 'package:card_battler/game/components/shared/card_deck.dart';
import 'package:card_battler/game/components/shared/card_pile.dart';
import 'package:card_battler/game/components/team/player_stats.dart';
import 'package:card_battler/game/models/enemy/enemy_turn_area_model.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart' show Colors;

/// Dedicated scene for Enemy Turn phase
/// Replaces the overlay-based EnemyTurnArea with a proper scene
class EnemyTurnScene extends Component {
  late RectangleComponent _playArea;
  late final CardDeck _deck;
  late final CardPile _playedCards;
  final EnemyTurnAreaModel _model;
  final VoidCallback? onSceneComplete;
  
  static const double fadeTime = 1.5;
  
  EnemyTurnScene({
    required EnemyTurnAreaModel model,
    this.onSceneComplete,
  }) : _model = model;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _createSceneContent();
    _startAnimation();
  }

  Future<void> _createSceneContent() async {
    // Create the main play area - similar to the original overlay
    _playArea = RectangleComponent(
      size: Vector2(size.x / 1.5, size.y / 1.5),
      anchor: Anchor.center,
      position: size / 2,
      paint: Paint()..color = Colors.black.withAlpha((255)),
    );

    add(_playArea);

    // Add deck component
    _deck = CardDeck(_model.enemyCards, onTap: () => _model.drawCardsFromDeck())
      ..anchor = Anchor.topLeft
      ..position = Vector2(0, 0)
      ..size = Vector2(_playArea.size.x * 0.25, _playArea.size.y / 2);

    _playArea.add(_deck);

    // Add played cards pile  
    _playedCards = CardPile(_model.playedCards, showNext: false)
      ..anchor = Anchor.topRight
      ..position = Vector2(_playArea.size.x, 0)
      ..size = Vector2(_playArea.size.x * 0.25, _playArea.size.y / 2);

    _playArea.add(_playedCards);

    // Add player stats
    final statsHeight = _playArea.size.y / 2 * 0.15;
    double currentY = _playArea.size.y / 2;
    for (int i = 0; i < _model.playerStats.length; i++) {
      var player = _model.playerStats[i];

      final playerStats = PlayerStats(model: player)
        ..size = Vector2(_playArea.size.x, statsHeight)
        ..position = Vector2(0, currentY);
      _playArea.add(playerStats);
      currentY += statsHeight;
    }
  }

  void _startAnimation() {
    _model.turnFinished = false;
    
    // Fade in animation
    _playArea.opacity = 0;
    _playArea.add(OpacityEffect.to(
      1.0,
      EffectController(duration: fadeTime),
    ));
  }

  /// Start the scene exit animation
  void exitScene() {
    _playArea.add(OpacityEffect.to(
      0.0,
      EffectController(duration: fadeTime),
      onComplete: () {
        removeFromParent();
        onSceneComplete?.call();
      },
    ));
  }
  
  /// Get the scene size - will be set by the game
  Vector2 get sceneSize => size;
}