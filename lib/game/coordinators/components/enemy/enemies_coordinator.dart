import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/enemy/enemy_coordinator.dart';

class EnemiesCoordinator {
  final List<EnemyCoordinator> _enemyCoordinators;
  final CardListCoordinator<CardCoordinator> _deckCardsCoordinator;
  final CardListCoordinator<CardCoordinator> _playedCardsCoordinator;

  final int _maxNumberOfEnemiesInPlay = 3;

  EnemiesCoordinator({
    required List<EnemyCoordinator> enemyCoordinators,
    required CardListCoordinator<CardCoordinator> deckCardsCoordinator,
    required CardListCoordinator<CardCoordinator> playedCardsCoordinator,
  }) : _deckCardsCoordinator = deckCardsCoordinator,
       _playedCardsCoordinator = playedCardsCoordinator,
       _enemyCoordinators = enemyCoordinators;

  List<EnemyCoordinator> get allEnemyCoordinators => _enemyCoordinators;
  CardListCoordinator<CardCoordinator> get deckCardsCoordinator =>
      _deckCardsCoordinator;
  CardListCoordinator<CardCoordinator> get playedCardsCoordinator =>
      _playedCardsCoordinator;

  int get numberOfEnemies => _enemyCoordinators.length;

  int get numberOfEnemiesNotInPlay =>
      numberOfEnemies - maxNumberOfEnemiesInPlay;

  int get maxNumberOfEnemiesInPlay => _maxNumberOfEnemiesInPlay;
}
