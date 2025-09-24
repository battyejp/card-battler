import 'package:card_battler/game/coordinators/components/scenes/enemy_turn_scene_coordinator.dart';
import 'package:card_battler/game/ui/components/card/containers/card_deck.dart';
import 'package:card_battler/game/ui/components/card/containers/card_pile.dart';
import 'package:flame/components.dart';

class EnemyTurn extends PositionComponent with HasVisibility {
  EnemyTurn(EnemyTurnSceneCoordinator coordinator) : _coordinator = coordinator;

  final EnemyTurnSceneCoordinator _coordinator;

  @override
  void onMount() {
    super.onMount();

    _loadGameComponents();
  }

  void _loadGameComponents() {
    final deckHeight = size.y * 0.3; //TODO perhaps use image size
    final deckWidth = size.x / 2 * 0.45; //TODO perhaps use image size

    final deck =
        CardDeck(_coordinator.drawCardsFromDeck, _coordinator.deckCardsCoordinator)
          ..size = Vector2(deckWidth, deckHeight)
          ..position = Vector2(0, size.y - deckHeight);

    add(deck);

    final playedCardsPile = CardPile(_coordinator.playedCardsCoordinator)
      ..size = Vector2(size.x / 2 * 0.45, deckHeight)
      ..position = Vector2(size.x - deckWidth, size.y - deckHeight);

    add(playedCardsPile);
  }
}
