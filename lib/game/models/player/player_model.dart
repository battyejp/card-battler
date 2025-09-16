import 'package:card_battler/game/models/card/card_list_model.dart';
import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/common/actor_model.dart';

class PlayerModel extends ActorModel {
  PlayerModel({
    required super.name,
    required super.healthModel,
    required this.handCards,
    required this.deckCards,
    required this.discardCards,
    required this.isActive,
    required this.credits,
    required this.attack,
  });

  final CardListModel<CardModel> handCards;
  final CardListModel<CardModel> deckCards;
  final CardListModel<CardModel> discardCards;
  bool isActive;
  int credits;
  int attack;
}
