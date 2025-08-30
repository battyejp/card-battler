import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shared/card_pile_model.dart';
import 'package:card_battler/game/models/team/player_stats_model.dart';
import 'package:flutter/foundation.dart';

class EnemyTurnAreaModel {
  final CardPileModel enemyCards;
  final CardPileModel playedCards;
  final List<PlayerStatsModel> playerStats;
  VoidCallback? onTurnFinished;
  bool turnFinished;

  EnemyTurnAreaModel({
    required this.enemyCards,
    required this.playerStats,
    this.onTurnFinished,
  })  : playedCards = CardPileModel.empty(),
        turnFinished = false;

  void drawCardsFromDeck() {
    if (turnFinished) return;

    final drawnCard = enemyCards.drawCard();

    if (drawnCard != null) {
      drawnCard.isFaceUp = true;

      playedCards.addCard(drawnCard);
      updatePlayersStats(drawnCard);
    }

    turnFinished = drawnCard?.effects.any((effect) => effect.type == EffectType.drawCard) == false;
    
    if (turnFinished) {
      onTurnFinished?.call();
    }
  }

  void updatePlayersStats(CardModel drawnCard) {
    for (var effect in drawnCard.effects) {
      switch (effect.type) {
        case EffectType.damage:
          switch (effect.target) {
            case EffectTarget.activePlayer:
              for (final stats in playerStats.where((player) => player.isActive)) {
	                stats.health.changeHealth(-effect.value);
	            }
              break;
            case EffectTarget.otherPlayers:
              for (final stats in playerStats.where((player) => !player.isActive)) {
	                stats.health.changeHealth(-effect.value);
	            }
              break;
            case EffectTarget.allPlayers:
              for (var stats in playerStats) {
                stats.health.changeHealth(-effect.value);
              }
              break;
            case EffectTarget.base:
            case EffectTarget.chosenPlayer:
              break;
          }
          break;
        case EffectType.drawCard:
          break;
      }
    }
  }
}