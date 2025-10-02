import 'package:card_battler/game/config/game_configuration.dart';
import 'package:card_battler/game/models/base/base_model.dart';
import 'package:card_battler/game/models/shared/health_model.dart';

/// Factory class responsible for creating base instances
/// Separates base creation logic from GameStateModel
class BaseFactory {
  /// Creates a list of bases for the game
  /// 
  /// [count] - Number of bases to create
  /// [config] - Game configuration containing health and other settings
  static List<BaseModel> createBases({
    required int count,
    required GameConfiguration config,
  }) =>
      List<BaseModel>.generate(
        count,
        (index) => createBase(index: index, config: config),
      );

  /// Creates a single base instance
  /// 
  /// [index] - Base index (0-based), used for naming
  /// [config] - Game configuration containing health and other settings
  static BaseModel createBase({
    required int index,
    required GameConfiguration config,
  }) =>
      BaseModel(
        name: 'Base ${index + 1}',
        healthModel: HealthModel(config.defaultHealth, config.defaultHealth),
      );
}
