import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';

mixin ActivePlayerChangeNotifier {
  final List<Function(PlayerCoordinator)> _activePlayerChangeListeners = [];

  void addActivePlayerChangeListener(Function(PlayerCoordinator) listener) {
    _activePlayerChangeListeners.add(listener);
  }

  void removeActivePlayerChangeListener(Function(PlayerCoordinator) listener) {
    _activePlayerChangeListeners.remove(listener);
  }

  void notifyActivePlayerChange(PlayerCoordinator newActivePlayer) {
    for (final listener in _activePlayerChangeListeners) {
      try {
        listener(newActivePlayer);
      } catch (e) {
        // Error handling
      }
    }
  }
}
