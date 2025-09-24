import 'dart:convert';

import 'package:card_battler/game/models/shared/effect_model.dart';

class CardModel {
  CardModel({
    required this.name,
    required this.type,
    required this.filename,
    List<EffectModel>? effects,
    this.isFaceUp = false,
  }) : effects = effects ?? [];

  factory CardModel.fromJson(Map<String, dynamic> json) {
    final effectsJson = json['effects'] as List<dynamic>?;
    final effects = effectsJson
        ?.map((effectJson) => EffectModel.fromJson(effectJson))
        .toList();

    return CardModel(
      name: json['name'],
      type: json['type'],
      filename: json['filename'],
      effects: effects,
    );
  }

  final String name;
  final String type;
  final String filename;
  final List<EffectModel> effects;
  bool isFaceUp;

  CardModel copy() => CardModel(
    name: name,
    type: type,
    effects: effects.map((e) => e.copy()).toList(),
    isFaceUp: isFaceUp,
    filename: filename,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type,
    'effects': effects.map((effect) => effect.toJson()).toList(),
    'faceUp': isFaceUp,
    'filename': filename,
  };
}

/// Loads cards from JSON string
///
/// Generic method that can load either CardModel or any subclass like ShopCardModel
/// The [fromJson] parameter is a factory function that creates instances of T from JSON
/// The [jsonString] parameter should contain the JSON data as a string
List<T> loadCardsFromJsonString<T>(
  String jsonString,
  T Function(Map<String, dynamic>) fromJson,
) {
  final List<dynamic> jsonData = json.decode(jsonString);
  return jsonData.map((json) => fromJson(json)).toList();
}
