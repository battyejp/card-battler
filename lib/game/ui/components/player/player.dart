import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/game_variables.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/ui/components/card/containers/card_deck.dart';
import 'package:card_battler/game/ui/components/card/containers/card_hand.dart';
import 'package:card_battler/game/ui/components/card/containers/card_pile.dart';
import 'package:card_battler/game/ui/components/shared/icon_stat.dart';
import 'package:card_battler/game/ui/components/shared/turn_button_component.dart';
import 'package:card_battler/game/ui/icon_manager.dart';
import 'package:flame/components.dart';

class Player extends PositionComponent {
  Player(PlayerCoordinator coordinator) : _coordinator = coordinator;

  final PlayerCoordinator _coordinator;
  final topMargin = 10.0;
  final cardOffesetInDeck = 10.0;
  final minCardTopMargin = 20.0;

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

    final deckHeight = GameVariables.defaultCardBackSizeHeight.toDouble();
    final deckWidth = GameVariables.defaultCardBackSizeWidth.toDouble();

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
            GameVariables.sideMargin +
                (cardOffesetInDeck *
                    2), //10 is to allow for card offsets in deck
            cardOffesetInDeck + topMargin,
          );

    add(deck);

    final discardPile =
        CardPile(_coordinator.discardCardsCoordinator, isMini: true)
          ..size = Vector2(deckWidth, deckHeight)
          ..position = Vector2(
            size.x - deckWidth - GameVariables.sideMargin,
            cardOffesetInDeck + topMargin,
          );

    add(discardPile);

    final attackIcon =
        IconStat(
            _coordinator.attackStatCoordinator,
            IconManager.target(),
            GameVariables.activePlayerStatsSize,
          )
          ..position = Vector2(
            size.x / 2 -
                GameVariables.activePlayerStatsSize / 2 +
                GameVariables.activePlayerStatsSize,
            discardPile.position.y,
          );
    add(attackIcon);

    final rupeeIcon =
        IconStat(
            _coordinator.creditsStatCoordinator,
            IconManager.rupee(),
            GameVariables.activePlayerStatsSize,
          )
          ..position = Vector2(
            size.x / 2 -
                GameVariables.activePlayerStatsSize / 2 -
                GameVariables.activePlayerStatsSize,
            discardPile.position.y,
          );
    add(rupeeIcon);

    final healthIcon =
        IconStat(
            _coordinator.healthStatCoordinator,
            IconManager.heart(),
            GameVariables.activePlayerStatsSize,
          )
          ..position = Vector2(
            rupeeIcon.position.x - GameVariables.activePlayerStatsSize,
            discardPile.position.y,
          );
    add(healthIcon);

    // // Add health text component to bottom right corner of health icon
    // _healthText = TextComponent(
    //   text: '${_coordinator.playerInfoCoordinator.health}',
    //   position: Vector2(healthIcon.size.x, healthIcon.size.y),
    //   anchor: Anchor.bottomRight,
    //   textRenderer: TextPaint(
    //     style: const TextStyle(
    //       fontSize: 24,
    //       color: Color(0xFFFFFFFF),
    //       fontWeight: FontWeight.bold,
    //     ),
    //   ),
    // );
    // healthIcon.add(_healthText);

    // const playerInfoHeight = 30.0;
    // final playerInfo = PlayerInfo(_coordinator.playerInfoCoordinator)
    //   ..size = Vector2(size.x, playerInfoHeight)
    //   ..position = Vector2(0, topMargin);
    // add(playerInfo);

    final turnBtn =
        TurnButtonComponent(_coordinator.turnButtonComponentCoordinator)
          ..size = Vector2(64, 64)
          ..position = Vector2(
            attackIcon.position.x +
                GameVariables.activePlayerStatsSize / 2 +
                GameVariables.activePlayerStatsSize,
            discardPile.position.y + 64 / 2,
          );
    add(turnBtn);

    final cardHand =
        CardHand(
            _coordinator.handCardsCoordinator,
            gamePhaseManager: _coordinator.gamePhaseManager,
          )
          ..size = Vector2(size.x, size.y)
          ..position = Vector2(
            0,
            deck.position.y + deckHeight + minCardTopMargin,
          );
    add(cardHand);
  }
}
