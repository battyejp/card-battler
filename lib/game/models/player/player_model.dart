import 'package:card_battler/game/models/card/cards_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';

class PlayerModel {
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
  });
}