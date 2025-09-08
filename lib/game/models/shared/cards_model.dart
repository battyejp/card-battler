import 'dart:math';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shared/reactive_model.dart';

class CardsModel<T extends CardModel> with ReactiveModel<CardsModel<T>> {
  final List<T> _cards;

  CardsModel({List<T>? cards})
      : _cards = cards ?? <T>[];

  CardsModel.empty() : _cards = [];

  /// Gets all cards (including defeated ones)
  List<T> get allCards => List.unmodifiable(_cards);

  /// Gets all cards (alias for backward compatibility)
  List<T> get cards => allCards;

  /// Checks if the card pile is empty
  bool get hasNoCards => _cards.isEmpty;

  /// Draws a specified number of cards from the top of the pile
  /// Returns the drawn cards and removes them from the pile
  List<T> drawCards(int count) {
    if (count <= 0) return [];
    
    final cardsToTake = count > _cards.length ? _cards.length : count;
    final drawnCards = _cards.take(cardsToTake).toList();
    _cards.removeRange(0, cardsToTake);
    
    notifyChange();
    return drawnCards;
  }

  /// Draws a single card from the top of the pile
  /// Returns null if the pile is empty
  T? drawCard() {
    if (_cards.isEmpty) return null;
    final card = _cards.removeAt(0);
    notifyChange();
    return card;
  }

  /// Adds a single card to the pile
  void addCard(T card) {
    _cards.add(card);
    notifyChange();
  }

  void addCards(List<T> cards) {
    _cards.addAll(cards);
    notifyChange();
  }

  /// Removes a specific card from the pile
  void removeCard(T card) {
    _cards.remove(card);
    notifyChange();
  }

  /// Clears all cards from the pile
  void clearCards() {
    _cards.clear();
    notifyChange();
  }

  /// Shuffles the cards in the pile using Fisher-Yates algorithm
  void shuffle() {
    final random = Random();
    for (int i = _cards.length - 1; i > 0; i--) {
      int j = random.nextInt(i + 1);
      final temp = _cards[i];
      _cards[i] = _cards[j];
      _cards[j] = temp;
    }
  }
}

// Backward compatibility typedef
// TODO remove this and update all references
typedef CardPileModel = CardsModel<CardModel>;