import '../game/game_phase_manager.dart';

mixin PhaseChangeNotifier {
  final List<Function(GamePhase, GamePhase)> _phaseChangeListeners = [];

  void addPhaseChangeListener(Function(GamePhase, GamePhase) listener) {
    _phaseChangeListeners.add(listener);
  }

  void removePhaseChangeListener(Function(GamePhase, GamePhase) listener) {
    _phaseChangeListeners.remove(listener);
  }

  void notifyPhaseChange(GamePhase previousPhase, GamePhase newPhase) {
    for (final listener in _phaseChangeListeners) {
      try {
        listener(previousPhase, newPhase);
      } catch (e) {
        // Log error - in production, use proper logging
      }
    }
  }

  void dispose() {
    _phaseChangeListeners.clear();
  }
}
