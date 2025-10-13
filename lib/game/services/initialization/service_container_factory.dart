import 'package:card_battler/game/coordinators/components/shared/turn_button_component_coordinator.dart';
import 'package:card_battler/game/coordinators/coordinators_manager.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/initialization/game_initialization_service.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';
import 'package:card_battler/game/services/ui/dialog_service.dart';

/// Factory responsible for creating and wiring up service dependencies
/// Handles dependency injection for the game's service layer
class ServiceContainerFactory {
  /// Creates a service container with all required services properly wired
  static ServiceContainer create(GameStateModel state) {
    final dialogService = DialogService();

    final gamePhaseManager = GamePhaseManager(
      numberOfPlayers: state.players.length,
    );

    final activePlayerManager = ActivePlayerManager(
      gamePhaseManager: gamePhaseManager,
    );

    final turnButtonComponentCoordinator = TurnButtonComponentCoordinator(
      dialogService: dialogService,
      gamePhaseManager: gamePhaseManager,
      activePlayerManager: activePlayerManager,
    );

    final coordinatorsManager = CoordinatorsManager(
      gamePhaseManager,
      state,
      activePlayerManager,
      dialogService,
      turnButtonComponentCoordinator,
    );

    return ServiceContainer(
      dialogService: dialogService,
      gamePhaseManager: gamePhaseManager,
      activePlayerManager: activePlayerManager,
      coordinatorsManager: coordinatorsManager,
    );
  }
}
