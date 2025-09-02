import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shared/reactive_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';

class ShopModel with ReactiveModel<ShopModel> {
  List<ShopCardModel> _allCards;
  List<ShopCardModel> _selectableCards;
  final int _numberOfRows;
  final int _numberOfColumns;

  Function(CardModel)? cardPlayed;

  ShopModel({
    required int numberOfRows,
    required int numberOfColumns,
    required List<ShopCardModel> cards,
  }) : _allCards = [],
       _selectableCards = [],
       _numberOfRows = numberOfRows,
       _numberOfColumns = numberOfColumns {
    // Calculate how many cards should be selectable
    final int displayCount = _numberOfRows * _numberOfColumns;

    if (cards.isNotEmpty) {
      if (cards.length <= displayCount) {
        _selectableCards = List.from(cards);
        _allCards = [];
      } else {
        _selectableCards = cards.take(displayCount).toList();
        _allCards = cards.skip(displayCount).toList();
      }
    }

    for(final card in _selectableCards) {
      card.onCardPlayed = () => _onCardPlayed(card);
    }
  }

  void _onCardPlayed(CardModel card) {
    card.onCardPlayed = null;
    cardPlayed?.call(card);
  }

  /// Removes a specific card from the hand
  void removeSelectableCardFromShop(CardModel card) {
    _selectableCards.remove(card);
    notifyChange();
  }

  List<ShopCardModel> get allCards => _allCards;
  List<ShopCardModel> get selectableCards => _selectableCards;
  int get numberOfRows => _numberOfRows;
  int get numberOfColumns => _numberOfColumns;
}
