import 'package:card_battler/game/coordinators/components/scenes/enemy_turn_scene_coordinator.dart';
import 'package:card_battler/game/game_variables.dart';
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
    const scale = 0.3;
    final deckSize = Vector2(
      GameVariables.defaultCardSizeWidth * scale,
      GameVariables.defaultCardSizeHeight * scale,
    );

    final deck =
        CardDeck(
            _coordinator.drawCardsFromDeck,
            _coordinator.deckCardsCoordinator,
            scale: scale,
            isMini: false,
          )
          ..position = Vector2(
            size.x / 4 - deckSize.x / 2,
            size.y / 2 - deckSize.y / 2,
          )
          ..size = deckSize * 1.1;

    add(deck);

    final playedCardsPile =
        CardPile(
            _coordinator.playedCardsCoordinator,
            showTopCard: true,
            scale: scale,
            isMini: false,
          )
          ..position = Vector2(
            (3 * size.x / 4) - deckSize.x / 2,
            size.y / 2 - deckSize.y / 2,
          )
          ..size = deckSize * 1.1;

    add(playedCardsPile);
  }
}
