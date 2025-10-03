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
      type: CardTypeHelper.fromString(json['type'] as String?),
      filename: json['filename'],
      effects: effects,
    );
  }

  final String name;
  final CardType type;
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
    'type': CardTypeHelper.toJsonString(type),
    'effects': effects.map((effect) => effect.toJson()).toList(),
    'faceUp': isFaceUp,
    'filename': filename,
  };
}

// CardType enum and helper for JSON conversion
enum CardType { hero, enemy, shop, unknown }

class CardTypeHelper {
  static CardType fromString(String? value) {
    if (value == null) {
      return CardType.unknown;
    }

    switch (value.toLowerCase()) {
      case 'hero':
        return CardType.hero;
      case 'enemy':
        return CardType.enemy;
      case 'shop':
        return CardType.shop;
      default:
        return CardType.unknown;
    }
  }

  static String toJsonString(CardType type) {
    switch (type) {
      case CardType.hero:
        return 'Hero';
      case CardType.enemy:
        return 'Enemy';
      case CardType.shop:
        return 'Shop';
      case CardType.unknown:
        return 'Unknown';
    }
  }
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
