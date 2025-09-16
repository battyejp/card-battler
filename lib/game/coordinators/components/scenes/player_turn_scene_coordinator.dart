import 'package:card_battler/game/coordinators/common/reactive_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/enemy/enemies_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/team_coordinator.dart';
import 'package:card_battler/game/services/card/effect_processor.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';

class PlayerTurnSceneCoordinator
    with ReactiveCoordinator<PlayerTurnSceneCoordinator> {
  late PlayerCoordinator _playerCoordinator;
  final ShopCoordinator _shopCoordinator;
  final TeamCoordinator _teamCoordinator;
  final EnemiesCoordinator _enemiesCoordinator;
  final EffectProcessor _effectProcessor;
  final GamePhaseManager _gamePhaseManager;
  final ActivePlayerManager _activePlayerManager;

  PlayerCoordinator get playerCoordinator => _playerCoordinator;
  ShopCoordinator get shopCoordinator => _shopCoordinator;
  TeamCoordinator get teamCoordinator => _teamCoordinator;
  EnemiesCoordinator get enemiesCoordinator => _enemiesCoordinator;
  EffectProcessor get effectProcessor => _effectProcessor;

  PlayerTurnSceneCoordinator({
    required PlayerCoordinator playerCoordinator,
    required ShopCoordinator shopCoordinator,
    required TeamCoordinator teamCoordinator,
    required EnemiesCoordinator enemiesCoordinator,
    required GamePhaseManager gamePhaseManager,
    required EffectProcessor effectProcessor,
    required ActivePlayerManager activePlayerManager,
  }) : _playerCoordinator = playerCoordinator,
       _shopCoordinator = shopCoordinator,
       _teamCoordinator = teamCoordinator,
       _enemiesCoordinator = enemiesCoordinator,
       _gamePhaseManager = gamePhaseManager,
       _activePlayerManager = activePlayerManager,
       _effectProcessor = effectProcessor {
    _shopCoordinator.onCardBought = (shopCardCoordinator) {
      onCardBought(shopCardCoordinator);
    };

    gamePhaseManager.addPhaseChangeListener(_onGamePhaseChanged);
    _activePlayerManager.addActivePlayerChangeListener(_onActivePlayerChanged);
  }

  void onCardBought(ShopCardCoordinator shopCardCoordinator) {
    _playerCoordinator.playerInfoCoordinator.adjustCredits(
      -shopCardCoordinator.cost,
    );
    _playerCoordinator.discardCardsCoordinator.addCard(shopCardCoordinator);
  }

  void _onActivePlayerChanged(PlayerCoordinator newActivePlayer) {
    _playerCoordinator = newActivePlayer;
    notifyChange();
  }

  void _onGamePhaseChanged(GamePhase previousPhase, GamePhase newPhase) {
    if (_isTurnOver(previousPhase, newPhase)) {
      _playerCoordinator.playerInfoCoordinator.resetCreditsAndAttack();
      _shopCoordinator.refillShop();

      var cards = _playerCoordinator.handCardsCoordinator.removeAllCards();

      if (_playerCoordinator.deckCardsCoordinator.isEmpty) {
        _refillDeck(cards);
      } else {
        _playerCoordinator.discardCardsCoordinator.addCards(cards);
      }
    }
  }

  void _refillDeck(List<CardCoordinator> handCards) {
    var discardCards = _playerCoordinator.discardCardsCoordinator
        .removeAllCards();

    var allCards = discardCards..addAll(handCards);
    _playerCoordinator.deckCardsCoordinator.addCards(allCards);
    _playerCoordinator.deckCardsCoordinator.shuffle();
  }

  bool _isTurnOver(GamePhase previousPhase, GamePhase newPhase) {
    return previousPhase == GamePhase.playerTakeActionsTurn &&
        newPhase == GamePhase.waitingToDrawPlayerCards;
  }

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
