import 'package:card_battler/game/coordinators/common/reactive_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/services/card/card_collection_service.dart';

class CardListCoordinator<T extends CardCoordinator>
    with ReactiveCoordinator<CardListCoordinator<T>> {
  CardListCoordinator({required List<T> cardCoordinators})
    : _collectionService = CardCollectionService<T>(
        cardCoordinators: cardCoordinators,
      );

  final CardCollectionService<T> _collectionService;
  List<T> get cardCoordinators => _collectionService.cardCoordinators;

  bool get hasCards => _collectionService.hasCards;

  bool get isEmpty => _collectionService.isEmpty;

  T drawCard({bool refreshUi = true}) =>
      drawCards(1, refreshUi: refreshUi).first;

  List<T> drawCards(int count, {bool refreshUi = true}) {
    final drawnCards = _collectionService.drawCards(count);

    if (refreshUi) {
      notifyChange();
    }

    return drawnCards;
  }

  void addCards(List<T> cards, {bool refreshUi = true}) {
    _collectionService.addCards(cards);

    if (refreshUi) {
      notifyChange();
    }
  }

  void addCard(T card, {bool refreshUi = true}) {
    addCards([card], refreshUi: refreshUi);
  }

  void removeCard(T card, {bool refreshUi = true}) {
    _collectionService.removeCard(card);

    if (refreshUi) {
      notifyChange();
    }
  }

  List<T> removeAllCards({bool refreshUi = true}) {
    final removedCards = _collectionService.removeAllCards();

    if (refreshUi) {
      notifyChange();
    }

    return removedCards;
  }

  void shuffle() {
    _collectionService.shuffle();
  }
}
