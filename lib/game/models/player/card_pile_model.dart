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

  /// Adds cards to the pile
  void addCards(List<CardModel> cards) {
    _cards.addAll(cards);
    notifyChange();
  }

  /// Adds a single card to the pile
  void addCard(CardModel card) {
    _cards.add(card);
    notifyChange();
  }
}