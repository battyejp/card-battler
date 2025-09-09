import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/services/shop/shop_inventory.dart';
import 'package:card_battler/game/services/shop/shop_display.dart';
import 'package:card_battler/game/services/shop/shop_layout.dart';
import 'package:card_battler/game/services/shop/shop_card_handler.dart';

/// Simple data holder for shop state
/// Contains only the shop services needed without any behavior
/// This class follows the Single Responsibility Principle by focusing solely on data storage
class ShopState {
  final ShopInventory inventory;
  final ShopDisplay display;
  final ShopLayout layout;
  final ShopCardHandler cardHandler;

  ShopState({
    required this.inventory,
    required this.display, 
    required this.layout,
    required this.cardHandler,
  });

  factory ShopState.create({
    required int numberOfRows,
    required int numberOfColumns,
    required List<ShopCardModel> cards,
  }) {
    final inventory = ShopInventory(cards: cards);
    final display = ShopDisplay();
    final layout = ShopLayout(numberOfRows: numberOfRows, numberOfColumns: numberOfColumns);
    final cardHandler = ShopCardHandler();
    
    return ShopState(
      inventory: inventory,
      display: display,
      layout: layout,
      cardHandler: cardHandler,
    );
  }
}