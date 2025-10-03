import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/services/turn/player_turn_lifecycle_manager.dart';

class GameScenePlayerHandler {
  GameScenePlayerHandler({
    required PlayerTurnLifecycleManager turnLifecycleManager,
    required Function(PlayerCoordinator) onPlayerChange,
  }) : _turnLifecycleManager = turnLifecycleManager,
       _onPlayerChange = onPlayerChange;

  final PlayerTurnLifecycleManager _turnLifecycleManager;
  final Function(PlayerCoordinator) _onPlayerChange;

  void handleActivePlayerChange(PlayerCoordinator newActivePlayer) {
    _turnLifecycleManager.updatePlayerCoordinator(newActivePlayer);
    _onPlayerChange(newActivePlayer);
  }
}
