import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/card/cards_model.dart';

class PlayerModel {
  final String name;
  final int maxHealth;
  final int attack;
  final int credits;
  final int health;
  final CardsModel<CardModel> handCards;
  final CardsModel<CardModel> deckCards;
  final CardsModel<CardModel> discardCards;
  final bool isActive;

  const PlayerModel({
    required this.attack,
    required this.credits,
    required this.health,
    required this.handCards,
    required this.deckCards,
    required this.discardCards,
    required this.isActive,
    required this.name,
    required this.maxHealth,
  });
}