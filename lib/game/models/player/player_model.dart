import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/card/card_list_model.dart';

class PlayerModel {
  final String name;
  final int maxHealth;
  final int attack;
  final CardListModel<CardModel> handCards;
  final CardListModel<CardModel> deckCards;
  final CardListModel<CardModel> discardCards;

  late bool isActive;
  late int health;
  late int credits;

  PlayerModel({
    required this.attack,
    required this.handCards,
    required this.deckCards,
    required this.discardCards,
    required this.isActive,
    required this.name,
    required this.maxHealth,
    required int currentHealth,
    required int currentCredits,
  })  : health = currentHealth,
        credits = currentCredits;
}
