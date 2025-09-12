import 'package:card_battler/game/models/base/base_model.dart';
import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';

class GameStateFacade {
  static GameStateFacade? _instance;

  final GameStateFactory _factory = GameStateFactory();
  GameStateModel? _state;

  GameStateFacade._();

  /// Gets the singleton instance of GameStateFacade
  static GameStateFacade get instance {
    _instance ??= GameStateFacade._();
    return _instance!;
  }

  /// Initializes the game state with provided cards
  /// This method delegates the complex creation logic to the factory
  void initialize(
    List<ShopCardModel> shopCards,
    List<CardModel> playerDeckCards,
    List<CardModel> enemyCards,
    List<BaseModel> bases,
  ) {
    _state = _factory.createGameState(shopCards, playerDeckCards, enemyCards, bases);
  }

  /// Gets the current game state, creating a default one if none exists
  GameStateModel get _ensuredState {
    _state ??= _factory.createDefaultGameState();
    return _state!;
  }

  /// Gets the enemy turn area for enemy turn logic
  GameStateModel get state => _ensuredState;
}