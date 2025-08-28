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
  }
}