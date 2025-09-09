import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/models/shared/cards_model.dart';

/// Manages the reserve card inventory for the shop
/// Single responsibility: Card inventory management
class ShopInventory {
  final CardsModel<ShopCardModel> _reserveCards;

  ShopInventory({required List<ShopCardModel> cards}) 
      : _reserveCards = CardsModel<ShopCardModel>() {
    _reserveCards.addCards(cards);
    _reserveCards.shuffle();
  }

  /// Draws a specified number of cards from the inventory
  List<ShopCardModel> drawCards(int count) {
    return _reserveCards.drawCards(count);
  }
}