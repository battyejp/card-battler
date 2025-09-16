import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/players_info_coordinator.dart';
import 'package:card_battler/game/services/card/effect_processor.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/turn/enemy_turn_manager.dart';

class EnemyTurnSceneCoordinator {
  EnemyTurnSceneCoordinator({
    required CardListCoordinator<CardCoordinator> playedCardsCoordinator,
    required CardListCoordinator<CardCoordinator> deckCardsCoordinator,
    required PlayersInfoCoordinator playersInfoCoordinator,
    required EffectProcessor effectProcessor,
    required GamePhaseManager gamePhaseManager,
    required int numberOfCardsToDrawPerEnemyTurn,
  }) : _playedCardsCoordinator = playedCardsCoordinator,
       _deckCardsCoordinator = deckCardsCoordinator,
       _playersInfoCoordinator = playersInfoCoordinator,
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
  final PlayersInfoCoordinator _playersInfoCoordinator;
  final EnemyTurnManager _turnManager;

  set numberOfCardsToDrawPerEnemyTurn(int value) =>
      _turnManager.numberOfCardsToDrawPerEnemyTurn = value;

  CardListCoordinator<CardCoordinator> get playedCardsCoordinator =>
      _playedCardsCoordinator;
  CardListCoordinator<CardCoordinator> get deckCardsCoordinator =>
      _deckCardsCoordinator;
  PlayersInfoCoordinator get playersCoordinator => _playersInfoCoordinator;

  void drawCardsFromDeck() {
    _turnManager.drawCardsFromDeck();
  }
}
