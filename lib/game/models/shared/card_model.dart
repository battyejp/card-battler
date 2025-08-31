import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

enum EffectType {
  attack,
  heal,
  credits,
  drawCard, //discard
  damageLimit;
  // placeNewCardOnDeck
  // random skill 
  // Search pile
  // BlockEnemy

  static EffectType fromString(String value) {
    return EffectType.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => throw ArgumentError('Unknown effect type: $value'),
    );
  }
}

enum EffectTarget {
  activePlayer,
  otherPlayers,
  allPlayers,
  base,
  chosenPlayer,
  self;

  static EffectTarget fromString(String value) {
    return EffectTarget.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => throw ArgumentError('Unknown effect target: $value'),
    );
  }
}

class EffectModel {
  final EffectType type;
  final EffectTarget target;
  final int value;

  EffectModel({
    required this.type,
    required this.target,
    required this.value,
  });

  factory EffectModel.fromJson(Map<String, dynamic> json) {
    return EffectModel(
      type: EffectType.fromString(json['type']),
      target: EffectTarget.fromString(json['target']),
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'target': target.name,
      'value': value,
    };
  }
}

class CardModel {
  final String _name;
  final String _type;
  final List<EffectModel> _effects;
  bool isFaceUp;

  CardModel({
    required String name,
    required String type,
    List<EffectModel>? effects,
    this.isFaceUp = false,
  }) : _name = name,
       _type = type,
       _effects = effects ?? [];

  String get name => _name;
  String get type => _type;
  List<EffectModel> get effects => List.unmodifiable(_effects);

  factory CardModel.fromJson(Map<String, dynamic> json) {
    final effectsJson = json['effects'] as List<dynamic>?;
    final effects = effectsJson
        ?.map((effectJson) => EffectModel.fromJson(effectJson))
        .toList();
    
    return CardModel(
      name: json['name'],
      type: json['type'],
      effects: effects,
      isFaceUp: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'type': _type,
      'effects': _effects.map((effect) => effect.toJson()).toList(),
      'faceUp': isFaceUp,
    };
  }
}

/// Loads cards from JSON file
/// 
/// Generic method that can load either CardModel or any subclass like ShopCardModel
/// The [fromJson] parameter is a factory function that creates instances of T from JSON
Future<List<T>> loadCardsFromJson<T>(
  String filePath, 
  T Function(Map<String, dynamic>) fromJson
) async {
  final String jsonString = await rootBundle.loadString(filePath);
  final List<dynamic> jsonData = json.decode(jsonString);
  return jsonData.map((json) => fromJson(json)).toList();
}
