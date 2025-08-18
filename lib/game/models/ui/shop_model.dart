import 'package:card_battler/game/models/shared/card_model.dart';

class ShopModel {
  List<CardModel> _allCards;
  List<CardModel> _selectableCards;
  final int _numberOfRows;
  final int _numberOfColumns;

  ShopModel({required int numberOfRows, required int numberOfColumns})
      : _allCards = [],
        _selectableCards = [],
        _numberOfRows = numberOfRows,
        _numberOfColumns = numberOfColumns {
    _generateShopItems();
  }

  void _generateShopItems() {
    _allCards = List.generate(
      10,
      (index) => CardModel(name: 'Card ${index + 1}', cost: 1),
    );

    var numberOfCardOnDisplay = _numberOfColumns * _numberOfRows;
    _selectableCards = List.from(_allCards.take(numberOfCardOnDisplay));
    _allCards.removeRange(0, numberOfCardOnDisplay);
  }

  List<CardModel> get allCards => _allCards;
  List<CardModel> get selectableCards => _selectableCards;
  int get numberOfRows => _numberOfRows;
  int get numberOfColumns => _numberOfColumns;

}