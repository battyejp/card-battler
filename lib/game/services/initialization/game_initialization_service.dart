import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/services/game/coordinators_manager.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/initialization/game_state_factory.dart';
import 'package:card_battler/game/services/initialization/service_container_factory.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';
import 'package:card_battler/game/services/ui/dialog_service.dart';

class ServiceContainer {
  ServiceContainer({
    required this.dialogService,
    required this.gamePhaseManager,
    required this.activePlayerManager,
    required this.coordinatorsManager,
  });

  final DialogService dialogService;
  final GamePhaseManager gamePhaseManager;
  final ActivePlayerManager activePlayerManager;
  final CoordinatorsManager coordinatorsManager;
}

class GameInitializationService {
  /// Initializes game state by delegating to GameStateFactory
  /// @deprecated Use GameStateFactory.create() directly for better separation of concerns
  static Future<GameStateModel> initializeGameState() =>
      GameStateFactory.create();

  /// Creates service container by delegating to ServiceContainerFactory
  /// @deprecated Use ServiceContainerFactory.create(state) directly for better separation of concerns
  static ServiceContainer createServices(GameStateModel state) =>
      ServiceContainerFactory.create(state);
}
