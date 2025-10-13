import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/services/card/effects/effect_processor.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';

class EnemyTurnManager {
  EnemyTurnManager({
    required CardListCoordinator<CardCoordinator> playedCardsCoordinator,
    required CardListCoordinator<CardCoordinator> deckCardsCoordinator,
    required EffectProcessor effectProcessor,
    required GamePhaseManager gamePhaseManager,
    required int numberOfCardsToDrawPerEnemyTurn,
  }) : _playedCardsCoordinator = playedCardsCoordinator,
       _deckCardsCoordinator = deckCardsCoordinator,
       _effectProcessor = effectProcessor,
       _gamePhaseManager = gamePhaseManager;

  final CardListCoordinator<CardCoordinator> _playedCardsCoordinator;
  final CardListCoordinator<CardCoordinator> _deckCardsCoordinator;
  final EffectProcessor _effectProcessor;
  final GamePhaseManager _gamePhaseManager;

  void drawCardsFromDeck() {
    if (_gamePhaseManager.currentPhase ==
        GamePhase.enemiesTurnCardsDrawnWaitingForPlayersTurn) {
      return;
    }

    final drawnCard = _deckCardsCoordinator.drawCard();
    _playedCardsCoordinator.addCard(drawnCard);
    _effectProcessor.applyCardEffects(drawnCard);
    _gamePhaseManager.nextPhase();
  }
}
