import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/shared/play_effects_model.dart';

class ShopCardModel extends CardModel {
  ShopCardModel({
    required super.name,
    required super.type,
    required super.filename,
    required super.playEffects,
    required this.cost,
    super.isFaceUp = true,
  });

  factory ShopCardModel.fromJson(Map<String, dynamic> json) => ShopCardModel(
    name: json['name'] as String,
    type: CardTypeHelper.fromString(json['type'] as String?),
    filename: json['filename'] as String,
    playEffects: json['playEffects'] != null
        ? PlayEffectsModel.fromJson(json['playEffects'] as Map<String, dynamic>)
        : PlayEffectsModel.empty(),
    cost: json['cost'] as int,
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
