import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shared/reactive_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';

class ShopModel with ReactiveModel<ShopModel> {
  final List<ShopCardModel> _reserveCards;
  final int _numberOfRows;
  final int _numberOfColumns;

  late int _displayCount;
  late List<ShopCardModel> _selectableCards;

  Function(CardModel)? cardPlayed;

  ShopModel({
    required int numberOfRows,
    required int numberOfColumns,
    required List<ShopCardModel> cards,
  }) : _reserveCards = [],
       _selectableCards = [],
       _numberOfRows = numberOfRows,
       _numberOfColumns = numberOfColumns {
    _displayCount = _numberOfRows * _numberOfColumns;

    _reserveCards.addAll(cards);
    _selectableCards = _getNewCardsForShopWithListenersAndRemoveFromReserve(_displayCount);
  }

  void _onCardPlayed(ShopCardModel card) {
    card.onCardPlayed = null;
    cardPlayed?.call(card);
  }

  void removeSelectableCardFromShop(ShopCardModel card) {
    _selectableCards.remove(card);
    notifyChange();
  }

  void refillShop() {
    var countToAdd = _displayCount - _selectableCards.length;

    if (countToAdd == 0) {
      return;
    }

    var newCards = _getNewCardsForShopWithListenersAndRemoveFromReserve(countToAdd);
    _selectableCards.addAll(newCards);
    notifyChange();
  }

  List<ShopCardModel> _getNewCardsForShopWithListenersAndRemoveFromReserve(int countToAdd) {
    var cards = _reserveCards.take(countToAdd).toList();
    for (final value in cards) {
      _reserveCards.remove(value);
    }

    for (final card in cards) {
      card.onCardPlayed = () => _onCardPlayed(card);
    }

    return cards;
  }

  List<ShopCardModel> get allCards => _reserveCards; //TODO remove this getter
  List<ShopCardModel> get selectableCards => _selectableCards;
  int get numberOfRows => _numberOfRows;
  int get numberOfColumns => _numberOfColumns;
}
