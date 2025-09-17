import 'package:card_battler/game/models/card/card_model.dart';

class CardListModel<T extends CardModel> {
  CardListModel({List<T>? cards}) : _cards = cards ?? <T>[];

  CardListModel.empty() : _cards = [];

  final List<T> _cards;

  List<T> get allCards => List.unmodifiable(_cards);

  bool get hasNoCards => _cards.isEmpty;
}