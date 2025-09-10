import 'package:card_battler/game/models/card/cards_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';

class ShopModel {
  final CardsModel<ShopCardModel> inventoryCards;
  final CardsModel<ShopCardModel> displayCards;

  ShopModel({
    required this.inventoryCards,
    required this.displayCards,
  });
}