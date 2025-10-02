import 'package:card_battler/game/config/game_configuration.dart';
import 'package:card_battler/game/models/card/card_list_model.dart';
import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/shared/health_model.dart';

/// Factory class responsible for creating player instances
/// Separates player creation logic from GameStateModel
class PlayerFactory {
  /// Creates a list of players for the game
  /// 
  /// [count] - Number of players to create
  /// [playerDeckCards] - Card list to use as starting deck for each player
  /// [config] - Game configuration containing health and other settings
  static List<PlayerModel> createPlayers({
    required int count,
    required List<CardModel> playerDeckCards,
    required GameConfiguration config,
  }) =>
      List<PlayerModel>.generate(count, (index) => createPlayer(
        index: index,
        playerDeckCards: playerDeckCards,
        config: config,
      ));

  /// Creates a single player instance
  /// 
  /// [index] - Player index (0-based), used for naming and determining active player
  /// [playerDeckCards] - Card list to use as starting deck
  /// [config] - Game configuration containing health and other settings
  static PlayerModel createPlayer({
    required int index,
    required List<CardModel> playerDeckCards,
    required GameConfiguration config,
  }) {
    final isActive = index == 0; // Only the first player is active
    final playerDeckCopy = List<CardModel>.from(
      playerDeckCards.map((card) => card.copy()),
    );
    
    return PlayerModel(
      name: 'Player ${index + 1}',
      healthModel: HealthModel(config.defaultHealth, config.defaultHealth),
      handCards: CardListModel<CardModel>.empty(),
      deckCards: CardListModel<CardModel>(cards: playerDeckCopy),
      discardCards: CardListModel<CardModel>.empty(),
      isActive: isActive,
      credits: config.playerStartingCredits,
      attack: config.playerStartingAttack,
    );
  }
}
