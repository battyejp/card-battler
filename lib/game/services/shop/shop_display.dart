import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/models/shared/reactive_model.dart';
import 'package:card_battler/game/models/shared/cards_model.dart';

/// Manages the currently displayed/selectable cards in the shop
/// Single responsibility: Display card management
class ShopDisplay with ReactiveModel<ShopDisplay> {
  CardsModel<ShopCardModel> _selectableCards;

  ShopDisplay({List<ShopCardModel>? initialCards}) 
      : _selectableCards = CardsModel<ShopCardModel>(cards: initialCards ?? []);

  /// Gets all currently displayed cards
  List<ShopCardModel> get displayedCards => _selectableCards.allCards;

  /// Adds cards to the display
  void addCards(List<ShopCardModel> cards) {
    _selectableCards.addCards(cards);
    notifyChange();
  }

  /// Removes a specific card from the display
  void removeCard(ShopCardModel card) {
    final cards = _selectableCards.allCards.toList();
    cards.remove(card);
    _selectableCards = CardsModel<ShopCardModel>(cards: cards);
    notifyChange();
  }

  /// Gets the number of empty slots for a given capacity
  int getEmptySlots(int maxCapacity) {
    return maxCapacity - _selectableCards.allCards.length;
  }
}