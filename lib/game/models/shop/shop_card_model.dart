import 'package:card_battler/game/models/card/card_model.dart';

class ShopCardModel extends CardModel {
  final int cost;

  ShopCardModel({
    required super.name,
    required this.cost,
    super.isFaceUp = true,
  }) : super(type: 'Shop');

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
