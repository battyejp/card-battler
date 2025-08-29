import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

enum AbilityType {
  damage,
  drawCard;

  static AbilityType fromString(String value) {
    return AbilityType.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => throw ArgumentError('Unknown ability type: $value'),
    );
  }
}

enum AbilityTarget {
  activePlayer,
  otherPlayers,
  allPlayers,
  base,
  chosenPlayer;

  static AbilityTarget fromString(String value) {
    return AbilityTarget.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => throw ArgumentError('Unknown ability target: $value'),
    );
  }
}

class AbilityModel {
  final AbilityType type;
  final AbilityTarget target;
  final int value;

  AbilityModel({
    required this.type,
    required this.target,
    required this.value,
  });

  factory AbilityModel.fromJson(Map<String, dynamic> json) {
    return AbilityModel(
      type: AbilityType.fromString(json['type']),
      target: AbilityTarget.fromString(json['target']),
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
  final List<AbilityModel> _abilities;
  bool isFaceUp;

  CardModel({
    required String name,
    required String type,
    List<AbilityModel>? abilities,
    this.isFaceUp = true,
  }) : _name = name,
       _type = type,
       _abilities = abilities ?? [];

  String get name => _name;
  String get type => _type;
  List<AbilityModel> get abilities => List.unmodifiable(_abilities);

  factory CardModel.fromJson(Map<String, dynamic> json) {
    final abilitiesJson = json['abilities'] as List<dynamic>?;
    final abilities = abilitiesJson
        ?.map((abilityJson) => AbilityModel.fromJson(abilityJson))
        .toList();
    
    return CardModel(
      name: json['name'],
      type: json['type'],
      abilities: abilities,
      isFaceUp: json['faceUp'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'type': _type,
      'abilities': _abilities.map((ability) => ability.toJson()).toList(),
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
