import 'package:card_battler/game/services/common/phase_change_notifier.dart';

enum GamePhase {
  /// Initial phase when waiting for player to draw cards
  waitingToDrawPlayerCards,

  /// Phase after player has drawn their cards but before enemy turn
  playerCardsDrawnWaitingForEnemyTurn,

  /// Enemy's turn to play cards and take actions
  enemyTurnWaitingToDrawCards,

  /// Phase after enemy has drawn their cards
  enemiesTurnCardsDrawnWaitingForPlayersTurn,

  /// Player's turn to play cards and take actions
  playerTakeActionsTurn,

  /// Phase to switch to the next player after cards have been drawn
  playerCardsDrawnWaitingForPlayerSwitch,
}

class GamePhaseManager with PhaseChangeNotifier {
  GamePhaseManager({required int numberOfPlayers})
    : _numberOfPlayers = numberOfPlayers;

  GamePhase _currentPhase = GamePhase.waitingToDrawPlayerCards;
  GamePhase _previousPhase = GamePhase.waitingToDrawPlayerCards;
  int _round = 0;
  int _playerTurn = 0;
  final int _numberOfPlayers;

  GamePhase get currentPhase => _currentPhase;

  GamePhase nextPhase() {
    switch (_currentPhase) {
      case GamePhase.playerCardsDrawnWaitingForEnemyTurn:
        _setPhase(GamePhase.enemyTurnWaitingToDrawCards);
        break;
      case GamePhase.enemyTurnWaitingToDrawCards:
        _setPhase(GamePhase.enemiesTurnCardsDrawnWaitingForPlayersTurn);
        break;
      case GamePhase.enemiesTurnCardsDrawnWaitingForPlayersTurn:
        _setPhase(GamePhase.playerTakeActionsTurn);
        break;
      case GamePhase.playerTakeActionsTurn:
        _setPhase(GamePhase.waitingToDrawPlayerCards);
        break;
      case GamePhase.waitingToDrawPlayerCards:
        if (_previousPhase == GamePhase.playerTakeActionsTurn) {
          _setPhase(GamePhase.playerCardsDrawnWaitingForPlayerSwitch);
        } else {
          _setPhase(GamePhase.playerCardsDrawnWaitingForEnemyTurn);
        }
        break;
      case GamePhase.playerCardsDrawnWaitingForPlayerSwitch:
        _playerTurn++;

        _playerTurn = _playerTurn % _numberOfPlayers;

        if (_playerTurn == 0) {
          _round++;
        }

        if (_round == 0) {
          _setPhase(GamePhase.waitingToDrawPlayerCards);
        } else {
          _setPhase(GamePhase.playerCardsDrawnWaitingForEnemyTurn);
        }
        break;
    }

    return _currentPhase;
  }

  void _setPhase(GamePhase newPhase) {
    if (_currentPhase != newPhase) {
      _previousPhase = _currentPhase;
      _currentPhase = newPhase;
      notifyPhaseChange(_previousPhase, newPhase);
    }
  }
}
