import 'dart:convert';
import 'package:card_battler/game/models/shared/effect_model.dart';

class CardModel {
  /// Creates a copy of this CardModel instance
  CardModel copy() {
    return CardModel(
      name: _name,
      type: _type,
      effects: _effects.map((e) => e.copy()).toList(),
      isFaceUp: isFaceUp,
      onCardPlayed: onCardPlayed,
    );
  }

  final String _name;
  final String _type;
  final List<EffectModel> _effects;
  bool isFaceUp;
  void Function()? onCardPlayed;

  CardModel({
    required String name,
    required String type,
    List<EffectModel>? effects,
    this.isFaceUp = false,
    this.onCardPlayed,
  }) : _name = name,
       _type = type,
       _effects = effects ?? [];

  String get name => _name;
  String get type => _type;
  List<EffectModel> get effects => List.unmodifiable(_effects);

  void playCard() {
    onCardPlayed?.call();
  }

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
