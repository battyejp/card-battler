import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/card/cards_model.dart';

class EnemyTurnModel {
  final CardsModel<CardModel> enemyCards;
  final CardsModel<CardModel> playedCards;
  //final PlayersModel playersModel;

  const EnemyTurnModel({
    required this.enemyCards,
    required this.playedCards,
    //required this.playersModel,
  });
}