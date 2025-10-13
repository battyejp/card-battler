import 'package:card_battler/game/coordinators/common/reactive_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/models/shared/effect_model.dart';
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

  bool containsCardOfType(EffectType type) =>
      _collectionService.cardCoordinators.any(
        (card) =>
            card.playEffects.effects.any((effect) => effect.type == type) ||
            card.handEffects.effects.any((effect) => effect.type == type),
      );

  List<T> getCardsOfType(EffectType type) => _collectionService.cardCoordinators
      .where(
        (card) =>
            card.playEffects.effects.any((effect) => effect.type == type) ||
            card.handEffects.effects.any((effect) => effect.type == type),
      )
      .toList();

  int? getEffectMinValueOfType(EffectType type) {
    final cardsOfType = getCardsOfType(type);
    final allValues = <int>[];
    for (final card in cardsOfType) {
      allValues.addAll(
        card.playEffects.effects
            .where((effect) => effect.type == type)
            .map((effect) => effect.value),
      );
      allValues.addAll(
        card.handEffects.effects
            .where((effect) => effect.type == type)
            .map((effect) => effect.value),
      );
    }
    if (allValues.isEmpty) {
      return null;
    }
    return allValues.reduce((a, b) => a < b ? a : b);
  }
}
