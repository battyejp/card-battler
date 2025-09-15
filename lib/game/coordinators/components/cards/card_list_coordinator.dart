import 'dart:math';

import 'package:card_battler/game/coordinators/common/reactive_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';

class CardListCoordinator<T extends CardCoordinator>
    with ReactiveCoordinator<CardListCoordinator<T>> {
  //TODO could this jusy inherit a List<CardCoordinator>?
  final List<T> _cardCoordinators;

  CardListCoordinator({required List<T> cardCoordinators})
    : _cardCoordinators = cardCoordinators;

  List<T> get cardCoordinators => _cardCoordinators;

  bool get hasCards => _cardCoordinators.isNotEmpty;

  bool get isEmpty => _cardCoordinators.isEmpty;

  List<T> drawCards(int count, {bool refreshUi = true}) {
    if (count <= 0) return [];

    final cardsToTake = count > _cardCoordinators.length
        ? _cardCoordinators.length
        : count;
    final drawnCards = _cardCoordinators.take(cardsToTake).toList();
    _cardCoordinators.removeRange(0, cardsToTake);

    for (var card in drawnCards) {
      card.isFaceUp = true;
    }

    if (refreshUi) {
      notifyChange();
    }

    return drawnCards;
  }

  void addCards(List<T> cards, {bool refreshUi = true}) {
    _cardCoordinators.addAll(cards);

    if (refreshUi) {
      notifyChange();
    }
  }

  void addCard(T card, {bool refreshUi = true}) {
    _cardCoordinators.add(card);

    if (refreshUi) {
      notifyChange();
    }
  }

  void removeCard(T card, {bool refreshUi = true}) {
    _cardCoordinators.remove(card);

    if (refreshUi) {
      notifyChange();
    }
  }

  List<T> removeAllCards({bool refreshUi = true}) {
    for (var card in _cardCoordinators) {
      card.onCardPlayed = null;
      card.isFaceUp = false;
    }

    final removedCards = List<T>.from(_cardCoordinators);
    _cardCoordinators.clear();

    if (refreshUi) {
      notifyChange();
    }

    return removedCards;
  }

  void shuffle() {
    _cardCoordinators.shuffle(Random());
  }
}
