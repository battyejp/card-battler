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

  List<T> drawCards(int count) {
    if (count <= 0) return [];

    final cardsToTake = count > _cardCoordinators.length
        ? _cardCoordinators.length
        : count;
    final drawnCards = _cardCoordinators.take(cardsToTake).toList();
    _cardCoordinators.removeRange(0, cardsToTake);

    for (var card in drawnCards) {
      card.isFaceUp = true;
    }

    notifyChange();
    return drawnCards;
  }

  void addCards(List<T> cards) {
    _cardCoordinators.addAll(cards);
    notifyChange();
  }

  void addCard(T card) {
    _cardCoordinators.add(card);
    notifyChange();
  }

  void removeCard(T card) {
    _cardCoordinators.remove(card);
    notifyChange();
  }
}
