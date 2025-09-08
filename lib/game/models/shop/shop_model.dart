
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shared/reactive_model.dart';
import 'package:card_battler/game/models/shared/cards_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';

//TODO split the class up
class ShopModel with ReactiveModel<ShopModel> {
  final CardsModel<ShopCardModel> _reserveCards;
  final int _numberOfRows;
  final int _numberOfColumns;

  late int _displayCount;
  late CardsModel<ShopCardModel> _selectableCards;

  Function(CardModel)? cardPlayed;

  ShopModel({
    required int numberOfRows,
    required int numberOfColumns,
    required List<ShopCardModel> cards,
  }) : _reserveCards = CardsModel<ShopCardModel>(),
       _selectableCards = CardsModel<ShopCardModel>(),
       _numberOfRows = numberOfRows,
       _numberOfColumns = numberOfColumns {
    _displayCount = _numberOfRows * _numberOfColumns;

    _reserveCards.addCards(cards);
    _reserveCards.shuffle();
    final newCards = _getNewCardsForShopWithListenersAndRemoveFromReserve(_displayCount);
    _selectableCards.addCards(newCards);
  }

  //TODO is this needed, could it just use base
  void _onCardPlayed(ShopCardModel card) {
    card.onCardPlayed = null;
    cardPlayed?.call(card);
  }

  void removeSelectableCardFromShop(ShopCardModel card) {
    final cards = _selectableCards.allCards.toList();
    cards.remove(card);
    _selectableCards = CardsModel<ShopCardModel>(cards: cards);
    notifyChange();
  }

  void refillShop() {
    var countToAdd = _displayCount - _selectableCards.allCards.length;

    if (countToAdd == 0) {
      return;
    }

    var newCards = _getNewCardsForShopWithListenersAndRemoveFromReserve(countToAdd);
    _selectableCards.addCards(newCards);
    notifyChange();
  }

  List<ShopCardModel> _getNewCardsForShopWithListenersAndRemoveFromReserve(int countToAdd) {
    var cards = _reserveCards.drawCards(countToAdd);

    for (final card in cards) {
      card.onCardPlayed = () => _onCardPlayed(card);
    }

    return cards;
  }

  List<ShopCardModel> get selectableCards => _selectableCards.allCards;
  int get numberOfRows => _numberOfRows;
  int get numberOfColumns => _numberOfColumns;
}
