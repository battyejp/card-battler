import 'package:card_battler/game_legacy/card_battler_game.dart';
import 'package:card_battler/game_legacy/components/shared/card/card_deck.dart';
import 'package:card_battler/game_legacy/components/shared/card/card_pile.dart';
import 'package:card_battler/game_legacy/components/team/players.dart';
import 'package:card_battler/game_legacy/services/enemy/enemy_turn_coordinator.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class EnemyTurnScene extends Component with HasGameReference<CardBattlerGame>{
  final EnemyTurnCoordinator _model;
  final Vector2 _size;

  EnemyTurnScene({required EnemyTurnCoordinator model, required Vector2 size})
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

    final players = Players(_model.playersModel, showActivePlayer: true)
      ..size = Vector2(_size.x, _size.y / 2)
      ..position = Vector2(0, _size.y / 2);
    playArea.add(players);   
  }
}