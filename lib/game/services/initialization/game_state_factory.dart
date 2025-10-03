import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/services/card/card_loader_service.dart';

/// Factory responsible for creating and initializing game state
/// Handles loading card data from JSON files and creating the initial game state
class GameStateFactory {
  /// Initializes game state by loading all required card data from assets
  static Future<GameStateModel> create() async {
    final playerDeckCards =
        await CardLoaderService.loadCardsFromJson<CardModel>(
      'assets/data/hero_starting_cards.json',
      CardModel.fromJson,
    );

    final enemyCards = await CardLoaderService.loadCardsFromJson<CardModel>(
      'assets/data/enemy_cards.json',
      CardModel.fromJson,
    );

    final shopCards = await CardLoaderService.loadCardsFromJson<ShopCardModel>(
      'assets/data/shop_cards.json',
      ShopCardModel.fromJson,
    );

    return GameStateModel.initialize(
      shopCards,
      playerDeckCards,
      enemyCards,
      [],
    );
  }
}
