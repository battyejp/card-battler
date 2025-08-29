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

    turnFinished = drawnCard?.abilities.any((ability) => ability.type == AbilityType.drawCard) == false;
    
    if (turnFinished) {
      onTurnFinished?.call();
    }
  }

  void updatePlayersStats(CardModel drawnCard) {
    for (var ability in drawnCard.abilities) {
      switch (ability.type) {
        case AbilityType.damage:
          switch (ability.target) {
            case AbilityTarget.activePlayer:
              for (final stats in playerStats.where((player) => player.isActive)) {
	                stats.health.changeHealth(-ability.value);
	            }
              break;
            case AbilityTarget.otherPlayers:
              for (final stats in playerStats.where((player) => !player.isActive)) {
	                stats.health.changeHealth(-ability.value);
	            }
              break;
            case AbilityTarget.allPlayers:
              for (var stats in playerStats) {
                stats.health.changeHealth(-ability.value);
              }
              break;
            case AbilityTarget.base:
            case AbilityTarget.chosenPlayer:
              break;
          }
          break;
        case AbilityType.drawCard:
          break;
      }
    }
  }
}