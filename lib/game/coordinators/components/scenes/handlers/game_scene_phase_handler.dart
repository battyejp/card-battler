import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/turn/player_turn_lifecycle_manager.dart';

class GameScenePhaseHandler {
  GameScenePhaseHandler({
    required PlayerTurnLifecycleManager turnLifecycleManager,
    required Function() onSceneChange,
  }) : _turnLifecycleManager = turnLifecycleManager,
       _onSceneChange = onSceneChange;

  final PlayerTurnLifecycleManager _turnLifecycleManager;
  final Function() _onSceneChange;

  void handlePhaseChange(GamePhase previousPhase, GamePhase newPhase) {
    if (_turnLifecycleManager.isTurnOver(previousPhase, newPhase)) {
      _turnLifecycleManager.handleTurnEnd();
    } else if (_turnLifecycleManager.hasSwitchedBetweenPlayerAndEnemyTurn(
      newPhase,
    )) {
      _onSceneChange();
    }
  }
}
