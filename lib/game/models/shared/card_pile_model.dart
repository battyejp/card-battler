import 'dart:math';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shared/reactive_model.dart';

class CardPileModel with ReactiveModel<CardPileModel> {
  final List<CardModel> _cards;

  CardPileModel({List<CardModel> cards = const []})
      : _cards = cards;

  CardPileModel.empty() : _cards = [];

  /// Gets all cards (including defeated ones)
  List<CardModel> get allCards => List.unmodifiable(_cards);

  /// Checks if the card pile is empty
  bool get hasNoCards => _cards.isEmpty;

  /// Draws a specified number of cards from the top of the pile
  /// Returns the drawn cards and removes them from the pile
  List<CardModel> drawCards(int count) {
    if (count <= 0) return [];
    
    final cardsToTake = count > _cards.length ? _cards.length : count;
    final drawnCards = _cards.take(cardsToTake).toList();
    _cards.removeRange(0, cardsToTake);
    
    notifyChange();
    return drawnCards;
  }

  /// Draws a single card from the top of the pile
  /// Returns null if the pile is empty
  CardModel? drawCard() {
    if (_cards.isEmpty) return null;
    final card = _cards.removeAt(0);
    notifyChange();
    return card;
  }

  /// Adds a single card to the pile
  void addCard(CardModel card) {
    _cards.add(card);
    notifyChange();
  }

  void addCards(List<CardModel> cards) {
    _cards.addAll(cards);
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
    notifyChange();
  }
}