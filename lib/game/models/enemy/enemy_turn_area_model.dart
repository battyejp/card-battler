
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shared/cards_model.dart';
import 'package:card_battler/game/models/team/players_model.dart';
import 'package:card_battler/game/services/game_state/game_state_service.dart';

class EnemyTurnAreaModel {
  final CardPileModel enemyCards;
  final CardPileModel playedCards;
  final PlayersModel playersModel;
  final GameStateService? _gameStateService;
  bool _turnFinished;

  //TODO break this class down
  EnemyTurnAreaModel({
    required this.enemyCards,
    //required this.playerStats,
    required this.playersModel,
    required GameStateService gameStateService,
  })  : playedCards = CardPileModel.empty(),
        _turnFinished = false,
        _gameStateService = gameStateService {
    enemyCards.shuffle();
  }

  void drawCardsFromDeck() {
    if (_turnFinished) return;

    final drawnCard = enemyCards.drawCard();
    _turnFinished = drawnCard?.effects.any((effect) => effect.type == EffectType.drawCard) == false;

    if (drawnCard != null) {
      drawnCard.isFaceUp = true;

      playedCards.addCard(drawnCard);
      updatePlayersStats(drawnCard);
    }

    if (_turnFinished) {
      _gameStateService?.nextPhase(); //Should be playerTurn
    }
  }

  void resetTurn() {
    _turnFinished = false;
  }

  void updatePlayersStats(CardModel drawnCard) {
    for (var effect in drawnCard.effects) {
      switch (effect.type) {
        case EffectType.attack:
          switch (effect.target) {
            case EffectTarget.activePlayer:
              for (final stats in playersModel.players.where((player) => player.isActive)) {
	                stats.health.changeHealth(-effect.value);
	            }
              break;
            case EffectTarget.otherPlayers:
              for (final stats in playersModel.players.where((player) => !player.isActive)) {
	                stats.health.changeHealth(-effect.value);
	            }
              break;
            case EffectTarget.allPlayers:
              for (var stats in playersModel.players) {
                stats.health.changeHealth(-effect.value);
              }
              break;
            case EffectTarget.base:
            case EffectTarget.chosenPlayer:
            case EffectTarget.self:
              break;
          }
          break;
        case EffectType.drawCard:
        case EffectType.heal:
        case EffectType.credits:
        case EffectType.damageLimit:
          break;
      }
    }
  }
}