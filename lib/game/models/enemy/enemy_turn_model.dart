import 'package:card_battler/game/models/card/card_list_model.dart';
import 'package:card_battler/game/models/card/card_model.dart';

class EnemyTurnModel {
  const EnemyTurnModel({required this.enemyCards, required this.playedCards});
  final CardListModel<CardModel> enemyCards;
  final CardListModel<CardModel> playedCards;
}
