import 'package:card_battler/game/coordinators/common/reactive_coordinator.dart';
import 'package:card_battler/game/coordinators/components/enemy/enemies_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/enemy_turn_scene_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/team_coordinator.dart';
import 'package:card_battler/game/services/card/effects/effect_processor.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';
import 'package:card_battler/game/services/turn/player_turn_lifecycle_manager.dart';

class GameSceneCoordinator with ReactiveCoordinator<GameSceneCoordinator> {
  GameSceneCoordinator({
    required PlayerCoordinator playerCoordinator,
    required ShopCoordinator shopCoordinator,
    required TeamCoordinator teamCoordinator,
    required EnemiesCoordinator enemiesCoordinator,
    required GamePhaseManager gamePhaseManager,
    required EffectProcessor effectProcessor,
    required ActivePlayerManager activePlayerManager,
    required EnemyTurnSceneCoordinator enemyTurnSceneCoordinator,
  }) : _playerCoordinator = playerCoordinator,
       _shopCoordinator = shopCoordinator,
       _teamCoordinator = teamCoordinator,
       _enemiesCoordinator = enemiesCoordinator,
       _gamePhaseManager = gamePhaseManager,
       _activePlayerManager = activePlayerManager,
       _enemyTurnSceneCoordinator = enemyTurnSceneCoordinator,
       _effectProcessor = effectProcessor,
       _turnLifecycleManager = PlayerTurnLifecycleManager(
         playerCoordinator: playerCoordinator,
         shopCoordinator: shopCoordinator,
       ) {
    _shopCoordinator.onCardBought = onCardBought;

    gamePhaseManager.addPhaseChangeListener(_onGamePhaseChanged);
    _activePlayerManager.addActivePlayerChangeListener(_onActivePlayerChanged);
  }

  late PlayerCoordinator _playerCoordinator;
  final ShopCoordinator _shopCoordinator;
  final TeamCoordinator _teamCoordinator;
  final EnemiesCoordinator _enemiesCoordinator;
  final EffectProcessor _effectProcessor;
  final GamePhaseManager _gamePhaseManager;
  final ActivePlayerManager _activePlayerManager;
  final PlayerTurnLifecycleManager _turnLifecycleManager;
  final EnemyTurnSceneCoordinator _enemyTurnSceneCoordinator;

  PlayerCoordinator get playerCoordinator => _playerCoordinator;
  ShopCoordinator get shopCoordinator => _shopCoordinator;
  TeamCoordinator get teamCoordinator => _teamCoordinator;
  EnemiesCoordinator get enemiesCoordinator => _enemiesCoordinator;
  EffectProcessor get effectProcessor => _effectProcessor;
  GamePhaseManager get gamePhaseManager => _gamePhaseManager;
  EnemyTurnSceneCoordinator get enemyTurnSceneCoordinator =>
      _enemyTurnSceneCoordinator;

  void onCardBought(ShopCardCoordinator shopCardCoordinator) {
    _playerCoordinator.playerInfoCoordinator.adjustCredits(
      -shopCardCoordinator.cost,
    );
    _playerCoordinator.discardCardsCoordinator.addCard(shopCardCoordinator);
  }

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

    _shopCoordinator.onCardBought = null;
    _gamePhaseManager.removePhaseChangeListener(_onGamePhaseChanged);
    _activePlayerManager.removeActivePlayerChangeListener(
      _onActivePlayerChanged,
    );
  }
}
