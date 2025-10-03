import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'active_player_change_notifier.dart';

class ActivePlayerManager with ActivePlayerChangeNotifier {
  ActivePlayerManager({required GamePhaseManager gamePhaseManager})
    : _gamePhaseManager = gamePhaseManager {
    _gamePhaseManager.addPhaseChangeListener((previousPhase, newPhase) {
      if (previousPhase == GamePhase.playerCardsDrawnWaitingForPlayerSwitch) {
        setNextPlayerToActive();
      }
    });
  }

  final GamePhaseManager _gamePhaseManager;
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
      notifyActivePlayerChange(_activePlayer!);
    }
  }

  void dispose() {
    _gamePhaseManager.removePhaseChangeListener((previousPhase, newPhase) {});
  }
}
