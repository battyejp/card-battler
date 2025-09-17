import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

/// Service responsible for loading cards from JSON files
/// This isolates Flutter dependencies from domain models
class CardLoaderService {
  /// Loads cards from JSON file using Flutter's rootBundle
  /// 
  /// Generic method that can load either CardModel or any subclass like ShopCardModel
  /// The [fromJson] parameter is a factory function that creates instances of T from JSON
  static Future<List<T>> loadCardsFromJson<T>(
    String filePath, 
    T Function(Map<String, dynamic>) fromJson
  ) async {
    final jsonString = await rootBundle.loadString(filePath);
    return loadCardsFromJsonString(jsonString, fromJson);
  }

  /// Loads cards from JSON string
  /// 
  /// Generic method that can load either CardModel or any subclass like ShopCardModel
  /// The [fromJson] parameter is a factory function that creates instances of T from JSON
  static List<T> loadCardsFromJsonString<T>(
    String jsonString,
    T Function(Map<String, dynamic>) fromJson
  ) {
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => fromJson(json as Map<String, dynamic>)).toList();
  }
}