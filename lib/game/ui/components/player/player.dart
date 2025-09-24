import 'dart:ui';

import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/game_variables.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/ui/components/card/containers/card_deck.dart';
import 'package:card_battler/game/ui/components/card/containers/card_fan.dart';
import 'package:card_battler/game/ui/components/card/containers/card_pile.dart';
import 'package:card_battler/game/ui/components/player/player_info.dart';
import 'package:flame/components.dart';

class Player extends PositionComponent {
  Player(PlayerCoordinator coordinator) : _coordinator = coordinator;

  final PlayerCoordinator _coordinator;

  @override
  void onMount() {
    super.onMount();

    final border = RectangleComponent(
      size: size,
      position: Vector2.zero(),
      paint: Paint()
        ..color = const Color.fromARGB(255, 255, 255, 255)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
    add(border);

    final cardFan =
        CardFan(
            _coordinator.handCardsCoordinator,
            gamePhaseManager: _coordinator.gamePhaseManager,
            fanRadius: 150.0,
            cardScale: 0.35,
          )
          ..size = Vector2(size.x, size.y)
          ..position = Vector2(
            0,
            0 +
                size.y -
                60, //TODO Need to figure out this for all screen sizes, probably based on fan radius
          );
    add(cardFan);

    final deckHeight = size.y * 0.3; //TODO perhaps use image size
    final deckWidth = size.x / 2 * 0.45; //TODO perhaps use image size

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
          ..position = Vector2(0, size.y - deckHeight);

    add(deck);

    final discardPile =
        CardPile(_coordinator.discardCardsCoordinator, isMini: true)
          ..size = Vector2(size.x / 2 * 0.45, deckHeight)
          ..position = Vector2(size.x - deckWidth, size.y - deckHeight);

    add(discardPile);

    final playerInfo = PlayerInfo(_coordinator.playerInfoCoordinator)
      ..size = Vector2(size.x, size.y)
      ..position = Vector2(0, 0);
    add(playerInfo);
  }
}
