import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/card/card_list_model.dart';

class PlayerModel {
  final String name;
  final int maxHealth;
  final CardListModel<CardModel> handCards;
  final CardListModel<CardModel> deckCards;
  final CardListModel<CardModel> discardCards;

  late bool isActive;
  late int health;
  late int credits;
  late int attack;

  PlayerModel({
    required this.handCards,
    required this.deckCards,
    required this.discardCards,
    required this.isActive,
    required this.name,
    required this.maxHealth,
    required int currentHealth,
    required int currentCredits,
    required int currentAttack,
  }) : health = currentHealth,
       credits = currentCredits,
       attack = currentAttack;
}
