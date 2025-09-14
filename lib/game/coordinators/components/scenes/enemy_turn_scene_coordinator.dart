import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/players_coordinator.dart';
import 'package:card_battler/game/services/card/effect_processor.dart';
import 'package:card_battler/game/services/game_state/game_phase_manager.dart';

class EnemyTurnSceneCoordinator {
  final CardListCoordinator<CardCoordinator> _playedCardsCoordinator;
  final CardListCoordinator<CardCoordinator> _deckCardsCoordinator;
  final PlayersCoordinator _playersCoordinator;
  final EffectProcessor _effectProcessor;
  final GamePhaseManager _gamePhaseManager;

  EnemyTurnSceneCoordinator({
    required CardListCoordinator<CardCoordinator> playedCardsCoordinator,
    required CardListCoordinator<CardCoordinator> deckCardsCoordinator,
    required PlayersCoordinator playersCoordinator,
    required EffectProcessor effectProcessor,
    required GamePhaseManager gamePhaseManager,
  }) : _playedCardsCoordinator = playedCardsCoordinator,
       _deckCardsCoordinator = deckCardsCoordinator,
       _playersCoordinator = playersCoordinator,
       _effectProcessor = effectProcessor,
       _gamePhaseManager = gamePhaseManager;

  CardListCoordinator<CardCoordinator> get playedCardsCoordinator =>
      _playedCardsCoordinator;
  CardListCoordinator<CardCoordinator> get deckCardsCoordinator =>
      _deckCardsCoordinator;
  PlayersCoordinator get playersCoordinator => _playersCoordinator;

  void drawCardsFromDeck() {
    if (_gamePhaseManager.currentPhase ==
        GamePhase.enemiesTurnCardsDrawnWaitingForPlayersTurn) {
      return;
    }

    //TODO determine number
    final drawnCards = deckCardsCoordinator.drawCards(1);

    if (drawnCards.isNotEmpty) {
      playedCardsCoordinator.addCards(drawnCards);
      _effectProcessor.applyCardEffects(drawnCards);
    }

    _gamePhaseManager.nextPhase();

    // if (_turnManager.isTurnFinished) {
    //   _turnManager.completeTurn(_state);
    // }
  }
}
