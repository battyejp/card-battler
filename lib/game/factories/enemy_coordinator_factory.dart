import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/enemy/enemies_coordinator.dart';
import 'package:card_battler/game/coordinators/components/enemy/enemy_coordinator.dart';
import 'package:card_battler/game/coordinators/components/enemy/enemy_turn_coordinator.dart';
import 'package:card_battler/game/models/enemy/enemies_model.dart';
import 'package:card_battler/game/services/card/effects/effect_processor.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';

class EnemyCoordinatorFactory {
  static List<EnemyCoordinator> createEnemyCoordinators({
    required EnemiesModel enemiesModel,
  }) => enemiesModel.enemies
      .map((enemy) => EnemyCoordinator(model: enemy))
      .toList();

  static EnemyTurnCoordinator createEnemyTurnSceneCoordinator({
    required EnemiesModel enemiesModel,
    required EffectProcessor effectProcessor,
    required GamePhaseManager gamePhaseManager,
    required ActivePlayerManager activePlayerManager,
    int numberOfCardsToDrawPerEnemyTurn = 1,
  }) => EnemyTurnCoordinator(
    playedCardsCoordinator: CardListCoordinator<CardCoordinator>(
      cardCoordinators: [],
    ),
    deckCardsCoordinator: CardListCoordinator<CardCoordinator>(
      cardCoordinators: enemiesModel.deckCards.allCards
          .map(
            (card) => CardCoordinator(
              cardModel: card.copy(),
              gamePhaseManager: gamePhaseManager,
              activePlayerManager: activePlayerManager,
            ),
          )
          .toList(),
    ),
    effectProcessor: effectProcessor,
    gamePhaseManager: gamePhaseManager,
    numberOfCardsToDrawPerEnemyTurn: numberOfCardsToDrawPerEnemyTurn,
  );

  static EnemiesCoordinator createEnemiesCoordinator({
    required List<EnemyCoordinator> enemyCoordinators,
    required EnemiesModel enemiesModel,
    required GamePhaseManager gamePhaseManager,
    required ActivePlayerManager activePlayerManager,
  }) => EnemiesCoordinator(
    enemyCoordinators: enemyCoordinators,
    deckCardsCoordinator: CardListCoordinator<CardCoordinator>(
      cardCoordinators: enemiesModel.deckCards.allCards
          .map(
            (card) => CardCoordinator(
              cardModel: card.copy(),
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
