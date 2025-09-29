import 'package:card_battler/game/models/card/card_model.dart';

class ShopCardModel extends CardModel {
  ShopCardModel({
    required super.name,
    required super.filename,
    required this.cost,
    super.isFaceUp = true,
  }) : super(type: CardType.shop);

  factory ShopCardModel.fromJson(Map<String, dynamic> json) => ShopCardModel(
    name: json['name'] as String,
    cost: json['cost'] as int,
    filename: json['filename'] as String,
    isFaceUp: json['faceUp'] as bool? ?? true,
  );

  final int cost;

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['cost'] = cost;
    return json;
  }
}
