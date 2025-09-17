import 'package:card_battler/game/models/card/card_list_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';

class ShopModel {
  ShopModel({required this.inventoryCards, required this.displayCards});
  final CardListModel<ShopCardModel> inventoryCards;
  final CardListModel<ShopCardModel> displayCards;
}
