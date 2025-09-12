import 'package:card_battler/game/coordinators/common/reactive_coordinator.dart';
import 'package:card_battler/game/coordinators/components/enemy/enemies_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/team_coordinator.dart';
import 'package:card_battler/game/services/game_state/game_phase_manager.dart';

class PlayerTurnSceneCoordinator
    with ReactiveCoordinator<PlayerTurnSceneCoordinator> {
  final PlayerCoordinator _playerCoordinator;
  final ShopCoordinator _shopCoordinator;
  final TeamCoordinator _teamCoordinator;
  final EnemiesCoordinator _enemiesCoordinator;
  final GamePhaseManager _gamePhaseManager;

  late String _buttonText = 'End Turn';
  late bool _buttonVisible = false;

  PlayerCoordinator get playerCoordinator => _playerCoordinator;
  ShopCoordinator get shopCoordinator => _shopCoordinator;
  TeamCoordinator get teamCoordinator => _teamCoordinator;
  EnemiesCoordinator get enemiesCoordinator => _enemiesCoordinator;
  String get buttonText => _buttonText;
  bool get isButtonVisible => _buttonVisible;

  //TODO think this needs access to all List of PlayerCoordinators
  PlayerTurnSceneCoordinator({
    required PlayerCoordinator playerCoordinator,
    required ShopCoordinator shopCoordinator,
    required TeamCoordinator teamCoordinator,
    required EnemiesCoordinator enemiesCoordinator,
    required GamePhaseManager gamePhaseManager,
  }) : _playerCoordinator = playerCoordinator,
       _shopCoordinator = shopCoordinator,
       _teamCoordinator = teamCoordinator,
       _enemiesCoordinator = enemiesCoordinator,
       _gamePhaseManager = gamePhaseManager {
    _gamePhaseManager.addPhaseChangeListener(_onGamePhaseChanged);
  }

  void handleTurnButtonPressed() {
    //TODO might need to deselect cards here
    _gamePhaseManager.nextPhase();
  }

  void _onGamePhaseChanged(GamePhase previousPhase, GamePhase newPhase) {
    // Determine new values
    String newButtonText = _buttonText;
    bool newButtonVisible = _buttonVisible;

    switch (newPhase) {
      case GamePhase.cardsDrawnWaitingForEnemyTurn:
        newButtonText = 'Take Enemy Turn';
        break;
      case GamePhase.playerTurn:
        newButtonText = 'End Turn';
        break;
      case GamePhase.cardsDrawnWaitingForPlayerSwitch:
        newButtonText = 'Switch Player';
        break;
      default:
        break;
    }

    newButtonVisible =
        newPhase != GamePhase.waitingToDrawCards &&
        newPhase != GamePhase.enemyTurn;

    // Only notify if something changed
    if (newButtonText != _buttonText || newButtonVisible != _buttonVisible) {
      _buttonText = newButtonText;
      _buttonVisible = newButtonVisible;
      notifyChange();
    }
  }

  //TODO think this needs to be called somewhere or perhaps is does automatically?
  @override
  void dispose() {
    super.dispose();
    _gamePhaseManager.removePhaseChangeListener(_onGamePhaseChanged);
  }
}
