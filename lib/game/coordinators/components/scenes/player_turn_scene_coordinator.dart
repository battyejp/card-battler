import 'package:card_battler/game/coordinators/common/reactive_coordinator.dart';
import 'package:card_battler/game/coordinators/components/enemy/enemies_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/team_coordinator.dart';
import 'package:card_battler/game/services/game_state/game_phase_manager.dart';

class PlayerTurnSceneCoordinator with ReactiveCoordinator<PlayerTurnSceneCoordinator> {
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
    _setupGameStateListener();
  }

  void _setupGameStateListener() {
    _gamePhaseManager.addPhaseChangeListener(_onGamePhaseChanged);
  }

  void _onGamePhaseChanged(GamePhase previousPhase, GamePhase newPhase) {

    switch (newPhase) {
      case GamePhase.cardsDrawnWaitingForEnemyTurn:
        _buttonText = 'Take Enemy Turn';
        break;
      case GamePhase.playerTurn:
        _buttonText = 'End Turn';
        break;
      case GamePhase.cardsDrawnWaitingForPlayerSwitch:
        _buttonText = 'Switch Player';
        break;
      default:
        break;
    }

    _buttonVisible =
        newPhase != GamePhase.waitingToDrawCards &&
        newPhase != GamePhase.enemyTurn;

    notifyChange();
  }

  //TODO think this needs to be called somewhere or perhaps is does automatically?
  @override
  void dispose() {
    _gamePhaseManager.removePhaseChangeListener(_onGamePhaseChanged);
  }
}
