import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/card/card_list_model.dart';

class EnemyTurnModel {
  final CardListModel<CardModel> enemyCards;
  final CardListModel<CardModel> playedCards;

  const EnemyTurnModel({
    required this.enemyCards,
    required this.playedCards,
  });
}
