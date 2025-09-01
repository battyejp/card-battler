import 'package:card_battler/game/card_battler_game.dart';
import 'package:card_battler/game/components/shared/card/card_deck.dart';
import 'package:card_battler/game/components/shared/card/card_pile.dart';
import 'package:card_battler/game/components/team/player_stats.dart';
import 'package:card_battler/game/models/enemy/enemy_turn_area_model.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

//TODO needs unit tests
class EnemyTurnScene extends Component with HasGameReference<CardBattlerGame>{
  final EnemyTurnAreaModel _model;
  final Vector2 _size;

  EnemyTurnScene({required EnemyTurnAreaModel model, required Vector2 size})
      : _model = model,
        _size = size {
      _loadGameComponents();
  }

  void _loadGameComponents() {

    var playArea = RectangleComponent(
      size: Vector2(_size.x, _size.y),
      anchor: Anchor.center,
      position: Vector2(0, 0),
      paint: Paint()..color = Colors.black.withAlpha((255)),
    );

    add(playArea);

    var deck = CardDeck(_model.enemyCards, onTap: () => _model.drawCardsFromDeck())
      ..anchor = Anchor.topLeft
      ..position = Vector2(0, 0)
      ..size = Vector2(_size.x * 0.25, _size.y / 2);

    playArea.add(deck);

    var playedCards = CardPile(_model.playedCards, showNext: false)
      ..anchor = Anchor.topRight
      ..position = Vector2(_size.x, 0)
      ..size = Vector2(_size.x * 0.25, _size.y / 2);

    playArea.add(playedCards);

    final statsHeight = _size.y / 2 * 0.15;
    double currentY = _size.y / 2;
    for (int i = 0; i < _model.playerStats.length; i++) {
      var player = _model.playerStats[i];

      final playerStats = PlayerStats(model: player)
        ..size = Vector2(_size.x, statsHeight)
        ..position = Vector2(0, currentY);
      playArea.add(playerStats);
      currentY += statsHeight;
    }    
  }
}