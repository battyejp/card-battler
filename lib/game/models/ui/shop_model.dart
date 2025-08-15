import 'package:card_battler/game/models/shared/card_model.dart';

class ShopModel {
  List<CardModel> _allCards;
  List<CardModel> _selectableCards;

  ShopModel() : _allCards = [], _selectableCards = [] {
    _generateShopItems();
  }

  void _generateShopItems() {
    _allCards = List.generate(
      10,
      (index) => CardModel(name: 'Card ${index + 1}', cost: 1),
    );

    //todo remove top 6 cards from _allCards and add to _selectableCards
    _selectableCards = List.from(_allCards.take(6));
    _allCards.removeRange(0, 6);
  }

  List<CardModel> get allCards => _allCards;
  List<CardModel> get selectableCards => _selectableCards;

}