import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class CardModel {
  final String _name;
  final String _type;
  bool isFaceUp;

  CardModel({required String name, required String type, this.isFaceUp = true})
      : _name = name,
        _type = type;

  String get name => _name;
  String get type => _type;

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      name: json['name'],
      type: json['type'],
      isFaceUp: json['faceUp'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'type': _type,
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
