import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';

class ActivePlayerManager {
  ActivePlayerManager({required GamePhaseManager gamePhaseManager})
    : _gamePhaseManager = gamePhaseManager {
    _gamePhaseManager.addPhaseChangeListener((previousPhase, newPhase) {
      if (previousPhase == GamePhase.playerCardsDrawnWaitingForPlayerSwitch) {
        setNextPlayerToActive();
      }
    });
  }

  final GamePhaseManager _gamePhaseManager;
  final List<Function(PlayerCoordinator newActivePlayer)>
  _activePlayerChangeListeners = [];
  late List<PlayerCoordinator> _players;

  set players(List<PlayerCoordinator> value) => _players = value;

  PlayerCoordinator? _activePlayer;

  PlayerCoordinator? get activePlayer => _activePlayer;

  void setNextPlayerToActive() {
    final initActive = _activePlayer == null;

    if (initActive) {
      _activePlayer = _players.first;
    } else {
      final currentIndex = _players.indexOf(_activePlayer!);
      final nextIndex = (currentIndex + 1) % _players.length;
      _activePlayer = _players[nextIndex];
    }

    for (final player in _players) {
      player.playerInfoCoordinator.isActive = player == _activePlayer;
    }

    if (!initActive) {
      _notifyActivePlayerChange(_activePlayer!);
    }
  }

  /// Add a listener for active player changes
  void addActivePlayerChangeListener(Function(PlayerCoordinator) listener) {
    _activePlayerChangeListeners.add(listener);
  }

  /// Remove a active player change listener
  void removeActivePlayerChangeListener(Function(PlayerCoordinator) listener) {
    _activePlayerChangeListeners.remove(listener);
  }

  void _notifyActivePlayerChange(PlayerCoordinator newActivePlayer) {
    for (final listener in _activePlayerChangeListeners) {
      try {
        listener(newActivePlayer);
      } catch (e) {
        // Continue notifying other listeners even if one fails
        // Log error - in production, this should use proper logging
        // print('Error in phase change listener: $e');
      }
    }
  }

  void dispose() {
    _gamePhaseManager.removePhaseChangeListener((previousPhase, newPhase) {});
  }
}
