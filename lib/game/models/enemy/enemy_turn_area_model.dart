import 'package:card_battler/game/models/shared/card_pile_model.dart';

class EnemyTurnAreaModel {
  final CardPileModel enemyCards;
  final CardPileModel playedCards;

  EnemyTurnAreaModel({
    required this.enemyCards,
  }) : playedCards = CardPileModel.empty();
}