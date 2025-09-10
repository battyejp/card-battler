
import 'package:card_battler/game/models/shared/card_model.dart';

class ShopCardModel extends CardModel {
  final int _cost;

  ShopCardModel({required super.name, required int cost, super.isFaceUp = true})
    : _cost = cost,
      super(type: 'Shop');

  int get cost => _cost;

  factory ShopCardModel.fromJson(Map<String, dynamic> json) {
    return ShopCardModel(
      name: json['name'],
      cost: json['cost'],
      isFaceUp: json['faceUp'] ?? true,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['cost'] = cost;
    return json;
  }
}
  