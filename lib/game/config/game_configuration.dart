/// Configuration class containing all game setup constants
/// This externalizes hardcoded values from GameStateModel.initialize()
class GameConfiguration {
  const GameConfiguration({
    this.numberOfPlayers = 5,
    this.numberOfEnemies = 4,
    this.numberOfBases = 3,
    this.defaultHealth = 10,
    this.playerStartingCredits = 0,
    this.playerStartingAttack = 0,
  });

  /// Number of players to create in the game
  final int numberOfPlayers;

  /// Number of enemies to create in the game
  final int numberOfEnemies;

  /// Number of bases to create in the game
  final int numberOfBases;

  /// Default health points for players, enemies, and bases
  final int defaultHealth;

  /// Starting credits for each player
  final int playerStartingCredits;

  /// Starting attack value for each player
  final int playerStartingAttack;

  /// Default game configuration
  static const GameConfiguration defaultConfig = GameConfiguration();
}
