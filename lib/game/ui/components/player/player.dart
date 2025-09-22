import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/game_variables.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/ui/components/card/containers/card_deck.dart';
import 'package:card_battler/game/ui/components/card/containers/card_pile.dart';
import 'package:card_battler/game/ui/components/player/card_hand.dart';
import 'package:card_battler/game/ui/components/player/player_info.dart';
import 'package:flame/components.dart';

class Player extends PositionComponent {
  Player({required PlayerCoordinator playerModel}) : _coordinator = playerModel;

  final _handWidthFactor = 0.6;
  final _infoHeightFactor = 0.1;
  final PlayerCoordinator _coordinator;

  @override
  void onLoad() {
    final infoHeight = size.y * _infoHeightFactor;
    final pileWidthFactor = (1 - _handWidthFactor) / 2;

    final deck = CardDeck(
      onTap: () => {
        if (_coordinator.gamePhaseManager.currentPhase ==
            GamePhase.waitingToDrawPlayerCards)
          {
            _coordinator.drawCardsFromDeck(
              GameVariables.numberOfCardsDrawnByPlayer,
            ),
          },
      },
      coordinator: _coordinator.deckCardsCoordinator,
    )..size = Vector2(size.x * pileWidthFactor, size.y);

    add(deck);

    final info =
        PlayerInfo(
            _coordinator.playerInfoCoordinator,
            viewMode: PlayerInfoViewMode.detailed,
          )
          ..size = Vector2(size.x * _handWidthFactor, infoHeight)
          ..position = Vector2(deck.x + deck.width, 0);

    add(info);

    final hand = CardHand(_coordinator.handCardsCoordinator)
      ..size = Vector2(size.x * _handWidthFactor, size.y - infoHeight)
      ..position = Vector2(deck.x + deck.width, infoHeight);

    add(hand);

    final discard = CardPile(_coordinator.discardCardsCoordinator, showNext: true)
      ..size = Vector2(size.x * pileWidthFactor, size.y)
      ..position = Vector2(hand.x + hand.width, 0);

    add(discard);
  }
}
