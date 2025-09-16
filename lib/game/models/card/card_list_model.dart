import 'package:card_battler/game/models/card/card_model.dart';

class CardListModel<T extends CardModel> {
  //TODO should this be a CardList and just inherit a List<CardModel>?
  final List<T> _cards;

  CardListModel({List<T>? cards}) : _cards = cards ?? <T>[];

  CardListModel.empty() : _cards = [];

  /// Gets all cards (including defeated ones)
  List<T> get allCards => List.unmodifiable(_cards);

  /// Checks if the card pile is empty
  bool get hasNoCards => _cards.isEmpty;
}