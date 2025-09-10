import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/card/cards_model.dart';

class CardsCoordinator {
  final CardsModel<CardModel> _cards;

  CardsCoordinator({required CardsModel<CardModel> cards}) : _cards = cards;

  CardsModel<CardModel> get cards => _cards;
}