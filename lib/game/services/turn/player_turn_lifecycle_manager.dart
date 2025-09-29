import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/shop_scene_coordinator.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';

class PlayerTurnLifecycleManager {
  PlayerTurnLifecycleManager({
    required PlayerCoordinator playerCoordinator,
    required ShopSceneCoordinator shopCoordinator,
  }) : _playerCoordinator = playerCoordinator,
       _shopCoordinator = shopCoordinator;

  PlayerCoordinator _playerCoordinator;
  final ShopSceneCoordinator _shopCoordinator;

  void updatePlayerCoordinator(PlayerCoordinator newPlayerCoordinator) {
    _playerCoordinator = newPlayerCoordinator;
  }

  void handleTurnEnd() {
    _playerCoordinator.playerInfoCoordinator.resetCreditsAndAttack();
    _shopCoordinator.refillShop();

    final cards = _playerCoordinator.handCardsCoordinator.removeAllCards();

    if (_playerCoordinator.deckCardsCoordinator.isEmpty) {
      _refillDeck(cards);
    } else {
      _playerCoordinator.discardCardsCoordinator.addCards(cards);
    }
  }

  void _refillDeck(List<CardCoordinator> handCards) {
    final discardCards = _playerCoordinator.discardCardsCoordinator
        .removeAllCards();

    final allCards = discardCards..addAll(handCards);
    _playerCoordinator.deckCardsCoordinator.addCards(allCards);
    _playerCoordinator.deckCardsCoordinator.shuffle();
  }

  bool isTurnOver(GamePhase previousPhase, GamePhase newPhase) =>
      previousPhase == GamePhase.playerTakeActionsTurn &&
      newPhase == GamePhase.waitingToDrawPlayerCards;

  bool hasSwitchedBetweenPlayerAndEnemyTurn(GamePhase newPhase) =>
      newPhase == GamePhase.enemyTurnWaitingToDrawCards ||
      newPhase == GamePhase.playerTakeActionsTurn;
}
