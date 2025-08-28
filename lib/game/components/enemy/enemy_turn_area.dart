import 'dart:ui';

import 'package:card_battler/game/components/shared/card_deck.dart';
import 'package:card_battler/game/components/shared/card_pile.dart';
import 'package:card_battler/game/components/shared/overlay.dart';
import 'package:card_battler/game/models/enemy/enemy_turn_area_model.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart' show Colors;

class EnemyTurnArea extends Overlay {
  late RectangleComponent _playArea;
  late final CardDeck _deck;
  late final CardPile _playedCards;
  final EnemyTurnAreaModel _model;

  EnemyTurnArea({
    super.displayDuration,
    super.onComplete,
    required EnemyTurnAreaModel model,
  })  : _model = model;

  @override
  void startAnimation() {
    super.startAnimation();
    _playArea.opacity = 0;
    _playArea.add(OpacityEffect.to(
      1.0,
      EffectController(duration: super.fadeDuration),
    ));
  }

  @override
  void startFadeOut() {
    super.startFadeOut();
    _playArea.add(OpacityEffect.to(
      0.0,
      EffectController(duration: super.fadeDuration),
    ));
  }

  @override
  void addContent() {
    super.addContent();
    _playArea = RectangleComponent(
      size: Vector2(size.x / 1.5, size.y / 1.5),
      anchor: Anchor.center,
      position: size / 2,
      paint: Paint()..color = Colors.black.withAlpha((255)),
    );

    backdrop.add(_playArea);

    _deck = CardDeck(_model.enemyCards, onTap: () => _drawCardsFromDeck())
      ..anchor = Anchor.centerLeft
      ..position = Vector2(0, _playArea.size.y / 2)
      ..size = Vector2(_playArea.size.x * 0.25, _playArea.size.y / 2);

    _playArea.add(_deck);

    _playedCards = CardPile(_model.playedCards, showNext: false)
      ..anchor = Anchor.centerRight
      ..position = Vector2(_playArea.size.x, _playArea.size.y / 2)
      ..size = Vector2(_playArea.size.x * 0.25, _playArea.size.y / 2);

    _playArea.add(_playedCards);
  }

  void _drawCardsFromDeck() {
    final drawnCard = _deck.model.drawCard();

    if (drawnCard != null) {
      drawnCard.isFaceUp = true;

      _playedCards.model.addCard(drawnCard);
    }
  }
}