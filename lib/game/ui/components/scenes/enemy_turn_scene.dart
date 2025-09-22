import 'package:card_battler/game/coordinators/components/scenes/enemy_turn_scene_coordinator.dart';
import 'package:card_battler/game/ui/components/card/containers/card_deck.dart';
import 'package:card_battler/game/ui/components/card/containers/card_pile.dart';
import 'package:card_battler/game/ui/components/player/player_info.dart';
import 'package:card_battler/game/ui/components/team/players.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class EnemyTurnScene extends Component {
  EnemyTurnScene({
    required Vector2 size,
    required EnemyTurnSceneCoordinator coordinator,
  }) : _size = size,
       _coordinator = coordinator;

  final Vector2 _size;
  final EnemyTurnSceneCoordinator _coordinator;

  @override
  void onMount() {
    super.onMount();

    _loadGameComponents();
  }

  void _loadGameComponents() {
    final playArea = RectangleComponent(
      size: Vector2(_size.x, _size.y),
      anchor: Anchor.center,
      position: Vector2(0, 0),
      paint: Paint()..color = Colors.black.withAlpha(255),
    );

    add(playArea);

    final deck =
        CardDeck(
            coordinator: _coordinator.deckCardsCoordinator,
            onTap: () => {_coordinator.drawCardsFromDeck()},
          )
          ..anchor = Anchor.topLeft
          ..position = Vector2(0, 0)
          ..size = Vector2(_size.x * 0.25, _size.y / 2);

    playArea.add(deck);

    final playedCards =
        CardPile(_coordinator.playedCardsCoordinator, showNext: false)
          ..anchor = Anchor.topRight
          ..position = Vector2(_size.x, 0)
          ..size = Vector2(_size.x * 0.25, _size.y / 2);

    playArea.add(playedCards);

    final team =
        Players(
            coordinator: _coordinator.playersCoordinator,
            showActivePlayer: true,
            viewMode: PlayerInfoViewMode.detailed
          )
          ..size = Vector2(_size.x, _size.y / 2)
          ..position = Vector2(0, _size.y / 2);

    playArea.add(team);
  }
}
