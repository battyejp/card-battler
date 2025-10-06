import 'dart:convert';

import 'package:card_battler/game/models/shared/play_effects_model.dart';

class CardModel {
  CardModel({
    required this.name,
    required this.type,
    required this.filename,
    required this.playEffects,
    this.isFaceUp = false,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    final playEffectsJson = json['playEffects'] as Map<String, dynamic>?;
    final playEffects = playEffectsJson != null
        ? PlayEffectsModel.fromJson(playEffectsJson)
        : PlayEffectsModel.empty();

    return CardModel(
      name: json['name'],
      type: CardTypeHelper.fromString(json['type'] as String?),
      filename: json['filename'],
      playEffects: playEffects,
    );
  }

  final String name;
  final CardType type;
  final String filename;
  final PlayEffectsModel playEffects;
  bool isFaceUp;

  CardModel copy() => CardModel(
    name: name,
    type: type,
    playEffects: playEffects.copy(),
    isFaceUp: isFaceUp,
    filename: filename,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': CardTypeHelper.toJsonString(type),
    'playEffects': playEffects.toJson(),
    'faceUp': isFaceUp,
    'filename': filename,
  };
}

// CardType enum and helper for JSON conversion
enum CardType { item, enemy, ally, unknown }

class CardTypeHelper {
  static CardType fromString(String? value) {
    if (value == null) {
      return CardType.unknown;
    }

    switch (value.toLowerCase()) {
      case 'item':
        return CardType.item;
      case 'enemy':
        return CardType.enemy;
      case 'ally':
        return CardType.ally;
      default:
        return CardType.unknown;
    }
  }

  static String toJsonString(CardType type) {
    switch (type) {
      case CardType.item:
        return 'Item';
      case CardType.enemy:
        return 'Enemy';
      case CardType.ally:
        return 'Ally';
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
