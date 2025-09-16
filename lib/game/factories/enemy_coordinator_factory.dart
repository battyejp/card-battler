import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/enemy/enemies_coordinator.dart';
import 'package:card_battler/game/coordinators/components/enemy/enemy_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/enemy_turn_scene_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/players_info_coordinator.dart';
import 'package:card_battler/game/models/enemy/enemies_model.dart';
import 'package:card_battler/game/services/card/cards_selection_manager_service.dart';
import 'package:card_battler/game/services/card/effects/effect_processor.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';

class EnemyCoordinatorFactory {
  static List<EnemyCoordinator> createEnemyCoordinators({
    required EnemiesModel enemiesModel,
  }) => enemiesModel.enemies
      .map((enemy) => EnemyCoordinator(model: enemy))
      .toList();

  static EnemyTurnSceneCoordinator createEnemyTurnSceneCoordinator({
    required EnemiesModel enemiesModel,
    required PlayersInfoCoordinator playersInfoCoordinator,
    required EffectProcessor effectProcessor,
    required GamePhaseManager gamePhaseManager,
    required CardsSelectionManagerService cardsSelectionManagerService,
    required ActivePlayerManager activePlayerManager,
    int numberOfCardsToDrawPerEnemyTurn = 1,
  }) => EnemyTurnSceneCoordinator(
      playedCardsCoordinator: CardListCoordinator<CardCoordinator>(
        cardCoordinators: [],
      ),
      deckCardsCoordinator: CardListCoordinator<CardCoordinator>(
        cardCoordinators: enemiesModel.deckCards.allCards
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
      playersInfoCoordinator: playersInfoCoordinator,
      effectProcessor: effectProcessor,
      gamePhaseManager: gamePhaseManager,
      numberOfCardsToDrawPerEnemyTurn: numberOfCardsToDrawPerEnemyTurn,
    );

  static EnemiesCoordinator createEnemiesCoordinator({
    required List<EnemyCoordinator> enemyCoordinators,
    required EnemiesModel enemiesModel,
    required CardsSelectionManagerService cardsSelectionManagerService,
    required GamePhaseManager gamePhaseManager,
    required ActivePlayerManager activePlayerManager,
  }) => EnemiesCoordinator(
      enemyCoordinators: enemyCoordinators,
      deckCardsCoordinator: CardListCoordinator<CardCoordinator>(
        cardCoordinators: enemiesModel.deckCards.allCards
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
      playedCardsCoordinator: CardListCoordinator<CardCoordinator>(
        cardCoordinators: [],
      ),
    );
}