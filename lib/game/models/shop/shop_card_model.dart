import 'package:card_battler/game/models/card/card_model.dart';

class ShopCardModel extends CardModel {
  ShopCardModel({
    required super.name,
    required super.filename,
    required this.cost,
    super.isFaceUp = true,
  }) : super(type: 'Shop');

  factory ShopCardModel.fromJson(Map<String, dynamic> json) => ShopCardModel(
    name: json['name'],
    cost: json['cost'],
    filename: json['filename'],
    isFaceUp: json['faceUp'] ?? true,
  );

  final int cost;

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['cost'] = cost;
    return json;
  }
}
