import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/services/card/effects/effect_processor.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/turn/enemy_turn_manager.dart';

class EnemyTurnCoordinator {
  EnemyTurnCoordinator({
    required CardListCoordinator<CardCoordinator> playedCardsCoordinator,
    required CardListCoordinator<CardCoordinator> deckCardsCoordinator,
    required EffectProcessor effectProcessor,
    required GamePhaseManager gamePhaseManager,
    required int numberOfCardsToDrawPerEnemyTurn,
  }) : _playedCardsCoordinator = playedCardsCoordinator,
       _deckCardsCoordinator = deckCardsCoordinator,
       _turnManager = EnemyTurnManager(
         playedCardsCoordinator: playedCardsCoordinator,
         deckCardsCoordinator: deckCardsCoordinator,
         effectProcessor: effectProcessor,
         gamePhaseManager: gamePhaseManager,
         numberOfCardsToDrawPerEnemyTurn: numberOfCardsToDrawPerEnemyTurn,
       ) {
    _deckCardsCoordinator.shuffle();
  }

  final CardListCoordinator<CardCoordinator> _playedCardsCoordinator;
  final CardListCoordinator<CardCoordinator> _deckCardsCoordinator;
  final EnemyTurnManager _turnManager;

  CardListCoordinator<CardCoordinator> get playedCardsCoordinator =>
      _playedCardsCoordinator;
  CardListCoordinator<CardCoordinator> get deckCardsCoordinator =>
      _deckCardsCoordinator;

  void drawCardsFromDeck() {
    _turnManager.drawCardsFromDeck();
  }
}
