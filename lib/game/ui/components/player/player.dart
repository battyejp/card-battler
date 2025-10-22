import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/game_variables.dart';
import 'package:card_battler/game/services/card/card_selection_service.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/ui/components/card/card_drop_area_table.dart';
import 'package:card_battler/game/ui/components/card/containers/card_deck.dart';
import 'package:card_battler/game/ui/components/card/containers/card_hand.dart';
import 'package:card_battler/game/ui/components/card/containers/card_pile.dart';
import 'package:card_battler/game/ui/components/shared/icon_stat_component.dart';
import 'package:card_battler/game/ui/components/shared/turn_button_component.dart';
import 'package:card_battler/game/ui/icon_manager.dart';
import 'package:flame/components.dart';

class Player extends PositionComponent {
  Player(
    PlayerCoordinator coordinator,
    CardSelectionService cardSelectionService,
    CardDropAreaTable cardDropAreaTable
  ) : _coordinator = coordinator,
      _cardSelectionService = cardSelectionService,
      _cardDropAreaTable = cardDropAreaTable;

  final PlayerCoordinator _coordinator;
  final CardSelectionService _cardSelectionService;
  final CardDropAreaTable _cardDropAreaTable;
  final topMargin = 10.0;
  final cardOffesetInDeck = 10.0;
  final minCardTopMargin = 20.0;

  @override
  void onMount() {
    super.onMount();

    const scale = 0.075;
    final deckHeight = GameVariables.originalCardSizeHeight.toDouble() * scale;
    final deckWidth = GameVariables.originalCardSizeWidth.toDouble() * scale;

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
            scale: scale,
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
        CardPile(_coordinator.discardCardsCoordinator, scale: scale)
          ..size = Vector2(deckWidth, deckHeight)
          ..position = Vector2(
            size.x - deckWidth - GameVariables.sideMargin,
            cardOffesetInDeck + topMargin,
          );

    add(discardPile);

    final attackIcon =
        IconStatComponent(
            _coordinator.attackStatCoordinator,
            IconManager.target(),
            GameVariables.activePlayerStatsSize,
          )
          ..position = Vector2(
            size.x / 2 - GameVariables.activePlayerStatsSize / 2,
            discardPile.position.y,
          );
    add(attackIcon);

    final rupeeIcon =
        IconStatComponent(
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
        IconStatComponent(
            _coordinator.healthStatCoordinator,
            IconManager.heart(),
            GameVariables.activePlayerStatsSize,
          )
          ..position = Vector2(
            rupeeIcon.position.x - GameVariables.activePlayerStatsSize,
            discardPile.position.y,
          );
    add(healthIcon);

    final turnBtn =
        TurnButtonComponent(_coordinator.turnButtonComponentCoordinator)
          ..size = Vector2(64, 64)
          ..position = Vector2(
            attackIcon.position.x +
                GameVariables.activePlayerStatsSize / 2 +
                GameVariables.activePlayerStatsSize +
                GameVariables.activePlayerStatsSize,
            discardPile.position.y + 64 / 2,
          );
    add(turnBtn);

    final cardHand =
        CardHand(
            _coordinator.handCardsCoordinator,
            cardSelectionService: _cardSelectionService,
            gamePhaseManager: _coordinator.gamePhaseManager,
            cardDropAreaTable: _cardDropAreaTable
          )
          ..size = Vector2(size.x, size.y - (deckHeight + minCardTopMargin))
          ..position = Vector2(
            0,
            deck.position.y + deckHeight + minCardTopMargin,
          );
    add(cardHand);
  }
}
