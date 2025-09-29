import 'package:card_battler/game/coordinators/common/reactive_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_card_coordinator.dart';
import 'package:card_battler/game/game_variables.dart';

class ShopDisplayCoordinator with ReactiveCoordinator<ShopDisplayCoordinator> {
  ShopDisplayCoordinator({
    required CardListCoordinator<ShopCardCoordinator> cardCoordinators,
  }) : _cardCoordinators = cardCoordinators;

  final CardListCoordinator<ShopCardCoordinator> _cardCoordinators;

  late Function(ShopCardCoordinator)? onCardBought;

  List<ShopCardCoordinator> get cardCoordinators =>
      _cardCoordinators.cardCoordinators;

  int get itemsPerRow => GameVariables.shopDisplayNumberOfColumns;
  int get numberOfRows => GameVariables.shopDisplayNumberOfRows;

  void addCards(List<ShopCardCoordinator> cards) {
    for (final card in cards) {
      card.onCardPlayed = _onCardPlayed;
    }
    _cardCoordinators.addCards(cards);
    notifyChange();
  }

  void removeCard(ShopCardCoordinator cardCoordinator) {
    _cardCoordinators.removeCard(cardCoordinator);
    notifyChange();
  }

  int get maxCards => itemsPerRow * numberOfRows;
  int get missingCards => maxCards - _cardCoordinators.cardCoordinators.length;

  void _onCardPlayed(CardCoordinator cardCoordinator) {
    cardCoordinator.onCardPlayed = null;
    final shopCardCoordinator = cardCoordinator as ShopCardCoordinator;
    removeCard(shopCardCoordinator);
    onCardBought?.call(shopCardCoordinator);
  }

  // Call if ever exit the game
  @override
  void dispose() {
    for (final card in _cardCoordinators.cardCoordinators) {
      card.onCardPlayed = null;
    }
  }
}
