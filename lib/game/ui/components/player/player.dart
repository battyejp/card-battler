import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/game_variables.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/ui/components/card/containers/card_deck.dart';
import 'package:card_battler/game/ui/components/card/containers/card_fan.dart';
import 'package:card_battler/game/ui/components/card/containers/card_pile.dart';
import 'package:card_battler/game/ui/components/player/player_info.dart';
import 'package:card_battler/game/ui/components/shared/turn_button_component.dart';
import 'package:flame/components.dart';

class Player extends PositionComponent {
  Player(PlayerCoordinator coordinator) : _coordinator = coordinator;

  final PlayerCoordinator _coordinator;

  @override
  void onMount() {
    super.onMount();

    // final border = RectangleComponent(
    //   size: size,
    //   position: Vector2.zero(),
    //   paint: Paint()
    //     ..color = const Color.fromARGB(255, 255, 255, 255)
    //     ..style = PaintingStyle.stroke
    //     ..strokeWidth = 1.0,
    // );
    // add(border);

    final cardFan =
        CardFan(
            _coordinator.handCardsCoordinator,
            gamePhaseManager: _coordinator.gamePhaseManager,
            fanRadius: 125.0,
            cardScale: GameVariables.activePlayerCardFanScale,
          )
          ..size = Vector2(size.x, size.y)
          ..position = Vector2(0, size.y);
    add(cardFan);

    final deckHeight = GameVariables.defaultCardBackSizeHeight.toDouble();
    final deckWidth = GameVariables.defaultCardBackSizeWidth.toDouble();
    final cardDeckYPosition = size.y - deckHeight - GameVariables.margin;

    final deck =
        CardDeck(
            () {
              if (_coordinator.gamePhaseManager.currentPhase ==
                  GamePhase.waitingToDrawPlayerCards) {
                _coordinator.drawCardsFromDeck(
                  GameVariables.numberOfCardsDrawnByPlayer,
                );
              }
            },
            _coordinator.deckCardsCoordinator,
            isMini: true,
          )
          ..size = Vector2(deckWidth, deckHeight)
          ..position = Vector2(
            GameVariables.margin + 10, //10 is to allow for card offsets in deck
            cardDeckYPosition,
          );

    add(deck);

    final discardPile =
        CardPile(_coordinator.discardCardsCoordinator, isMini: true)
          ..size = Vector2(deckWidth, deckHeight)
          ..position = Vector2(
            size.x - deckWidth - GameVariables.margin,
            cardDeckYPosition,
          );

    add(discardPile);

    final playerInfo = PlayerInfo(_coordinator.playerInfoCoordinator)
      ..size = Vector2(size.x, size.y)
      ..position = Vector2(
        0,
        discardPile.position.y -
            discardPile.size.y -
            40.0, //TODO look at this value
      );
    add(playerInfo);

    final turnBtn =
        TurnButtonComponent(_coordinator.turnButtonComponentCoordinator)
          ..size = Vector2(100, 25)
          ..position = Vector2(
            size.x - 50 - GameVariables.margin,
            discardPile.position.y -
                discardPile.size.y -
                40.0, //TODO look at this value
          );
    add(turnBtn);
  }
}
