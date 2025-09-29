import 'package:card_battler/game/coordinators/common/reactive_coordinator.dart';
import 'package:card_battler/game/coordinators/components/enemy/enemies_coordinator.dart';
import 'package:card_battler/game/coordinators/components/enemy/enemy_turn_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/shop_scene_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shared/turn_button_component_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/team_coordinator.dart';
import 'package:card_battler/game/services/card/effects/effect_processor.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';
import 'package:card_battler/game/services/turn/player_turn_lifecycle_manager.dart';

class GameSceneCoordinator with ReactiveCoordinator<GameSceneCoordinator> {
  GameSceneCoordinator({
    required PlayerCoordinator playerCoordinator,
    required ShopSceneCoordinator shopCoordinator,
    required TeamCoordinator teamCoordinator,
    required EnemiesCoordinator enemiesCoordinator,
    required GamePhaseManager gamePhaseManager,
    required EffectProcessor effectProcessor,
    required ActivePlayerManager activePlayerManager,
    required EnemyTurnCoordinator enemyTurnSceneCoordinator,
    required TurnButtonComponentCoordinator turnButtonComponentCoordinator,
  }) : _playerCoordinator = playerCoordinator,
      //  _shopCoordinator = shopCoordinator,
       _teamCoordinator = teamCoordinator,
       _enemiesCoordinator = enemiesCoordinator,
       _gamePhaseManager = gamePhaseManager,
       _activePlayerManager = activePlayerManager,
       _enemyTurnSceneCoordinator = enemyTurnSceneCoordinator,
       _effectProcessor = effectProcessor,
       _turnButtonComponentCoordinator = turnButtonComponentCoordinator,
       _turnLifecycleManager = PlayerTurnLifecycleManager(
         playerCoordinator: playerCoordinator,
         shopCoordinator: shopCoordinator,
       ) {
    gamePhaseManager.addPhaseChangeListener(_onGamePhaseChanged);
    _activePlayerManager.addActivePlayerChangeListener(_onActivePlayerChanged);
  }

  late PlayerCoordinator _playerCoordinator;
  //final ShopSceneCoordinator _shopCoordinator;
  final TeamCoordinator _teamCoordinator;
  final EnemiesCoordinator _enemiesCoordinator;
  final EffectProcessor _effectProcessor;
  final GamePhaseManager _gamePhaseManager;
  final ActivePlayerManager _activePlayerManager;
  final PlayerTurnLifecycleManager _turnLifecycleManager;
  final EnemyTurnCoordinator _enemyTurnSceneCoordinator;
  final TurnButtonComponentCoordinator _turnButtonComponentCoordinator;

  PlayerCoordinator get playerCoordinator => _playerCoordinator;
  //ShopSceneCoordinator get shopCoordinator => _shopCoordinator;
  TeamCoordinator get teamCoordinator => _teamCoordinator;
  EnemiesCoordinator get enemiesCoordinator => _enemiesCoordinator;
  EffectProcessor get effectProcessor => _effectProcessor;
  GamePhaseManager get gamePhaseManager => _gamePhaseManager;
  TurnButtonComponentCoordinator get turnButtonComponentCoordinator =>
      _turnButtonComponentCoordinator;
  EnemyTurnCoordinator get enemyTurnSceneCoordinator =>
      _enemyTurnSceneCoordinator;

  void _onActivePlayerChanged(PlayerCoordinator newActivePlayer) {
    _playerCoordinator = newActivePlayer;
    _turnLifecycleManager.updatePlayerCoordinator(newActivePlayer);
    notifyChange();
  }

  void _onGamePhaseChanged(GamePhase previousPhase, GamePhase newPhase) {
    if (_turnLifecycleManager.isTurnOver(previousPhase, newPhase)) {
      _turnLifecycleManager.handleTurnEnd();
    } else if (_turnLifecycleManager.hasSwitchedBetweenPlayerAndEnemyTurn(
      newPhase,
    )) {
      notifyChange();
    }
  }

  bool get isEnemyTurnSceneVisible =>
      _gamePhaseManager.currentPhase ==
          GamePhase.enemiesTurnCardsDrawnWaitingForPlayersTurn ||
      _gamePhaseManager.currentPhase == GamePhase.enemyTurnWaitingToDrawCards;

  @override
  void dispose() {
    super.dispose();

    _gamePhaseManager.removePhaseChangeListener(_onGamePhaseChanged);
    _activePlayerManager.removeActivePlayerChangeListener(
      _onActivePlayerChanged,
    );
  }
}
