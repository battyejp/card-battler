import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shared/card_pile_model.dart';
import 'package:card_battler/game/models/team/player_stats_model.dart';

class EnemyTurnAreaModel {
  final CardPileModel enemyCards;
  final CardPileModel playedCards;
  final List<PlayerStatsModel> playerStats;
  bool turnFinished;

  EnemyTurnAreaModel({
    required this.enemyCards,
    required this.playerStats,
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

    turnFinished = true;
  }

  void updatePlayersStats(CardModel drawnCard) {
    for (var ability in drawnCard.abilities) {
      switch (ability.type) {
        case AbilityType.damage:
          switch (ability.target) {
            case AbilityTarget.activePlayer:
              playerStats.where((player) => player.isActive).forEach((stats) {
                stats.health.changeHealth(-ability.value);
              });
              break;
            case AbilityTarget.otherPlayers:
            case AbilityTarget.allPlayers:
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