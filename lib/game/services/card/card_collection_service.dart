import 'dart:math';

import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';

class CardCollectionService<T extends CardCoordinator> {
  CardCollectionService({required List<T> cardCoordinators})
      : _cardCoordinators = cardCoordinators;

  final List<T> _cardCoordinators;

  List<T> get cardCoordinators => _cardCoordinators;
  bool get hasCards => _cardCoordinators.isNotEmpty;
  bool get isEmpty => _cardCoordinators.isEmpty;

  List<T> drawCards(int count) {
    if (count <= 0) {
      return [];
    }

    final cardsToTake = count > _cardCoordinators.length
        ? _cardCoordinators.length
        : count;
    final drawnCards = _cardCoordinators.take(cardsToTake).toList();
    _cardCoordinators.removeRange(0, cardsToTake);

    for (final card in drawnCards) {
      card.isFaceUp = true;
    }

    return drawnCards;
  }

  void addCards(List<T> cards) {
    _cardCoordinators.addAll(cards);
  }

  void addCard(T card) {
    _cardCoordinators.add(card);
  }

  void removeCard(T card) {
    _cardCoordinators.remove(card);
  }

  List<T> removeAllCards() {
    for (final card in _cardCoordinators) {
      card.onCardPlayed = null;
      card.isFaceUp = false;
    }

    final removedCards = List<T>.from(_cardCoordinators);
    _cardCoordinators.clear();

    return removedCards;
  }

  void shuffle() {
    _cardCoordinators.shuffle(Random());
  }
}