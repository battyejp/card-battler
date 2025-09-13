import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/card/card_list_model.dart';

class PlayerModel {
  final String name;
  final int maxHealth;
  final int attack;
  final int credits;
  final CardListModel<CardModel> handCards;
  final CardListModel<CardModel> deckCards;
  final CardListModel<CardModel> discardCards;
  final bool isActive;

  late int health;

  PlayerModel({
    required this.attack,
    required this.credits,
    required this.handCards,
    required this.deckCards,
    required this.discardCards,
    required this.isActive,
    required this.name,
    required this.maxHealth,
    required int currentHealth,
  }) : health = currentHealth;
}
