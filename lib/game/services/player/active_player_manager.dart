import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';

class ActivePlayerManager {
  late List<PlayerCoordinator> _players;
  ActivePlayerManager();

  set players(List<PlayerCoordinator> value) => _players = value;

  PlayerCoordinator? _activePlayer;

  PlayerCoordinator? get activePlayer => _activePlayer;

  void setNextPlayerToActive() {
    if (_activePlayer == null) {
      _activePlayer = _players.first;
    } else {
      var currentIndex = _players.indexOf(_activePlayer!);
      var nextIndex = (currentIndex + 1) % _players.length;
      _activePlayer = _players[nextIndex];
    }

    for (var player in _players) {
      player.playerInfoCoordinator.isActive = player == _activePlayer;
    }
  }
}
