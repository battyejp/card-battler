import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/players_info_coordinator.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/services/card/cards_selection_manager_service.dart';
import 'package:card_battler/game/services/card/effects/effect_processor.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';

class PlayerCoordinatorFactory {
  static List<PlayerCoordinator> createPlayerCoordinators({
    required List<PlayerModel> players,
    required GamePhaseManager gamePhaseManager,
    required ActivePlayerManager activePlayerManager,
    required CardsSelectionManagerService cardsSelectionManagerService,
    required EffectProcessor effectProcessor,
  }) => players.map((player) {
    final handCardsCoordinator = CardListCoordinator<CardCoordinator>(
      cardCoordinators: [],
    );

    return PlayerCoordinator(
      handCardsCoordinator: handCardsCoordinator,
      deckCardsCoordinator: CardListCoordinator<CardCoordinator>(
        cardCoordinators: player.deckCards.allCards
            .map(
              (card) => CardCoordinator(
                cardModel: card.copy(),
                cardsSelectionManagerService: cardsSelectionManagerService,
                gamePhaseManager: gamePhaseManager,
                activePlayerManager: activePlayerManager,
              ),
            )
            .toList(),
      ),
      discardCardsCoordinator: CardListCoordinator<CardCoordinator>(
        cardCoordinators: [],
      ),
      playerInfoCoordinator: PlayerInfoCoordinator(
        player,
        handCardsCoordinator,
      ),
      gamePhaseManager: gamePhaseManager,
      effectProcessor: effectProcessor,
    );
  }).toList();

  static PlayersInfoCoordinator createPlayersInfoCoordinator({
    required List<PlayerCoordinator> playerCoordinators,
  }) => PlayersInfoCoordinator(
    players: playerCoordinators.map((pc) => pc.playerInfoCoordinator).toList(),
  );
}
