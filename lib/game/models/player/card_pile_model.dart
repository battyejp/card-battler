import 'package:card_battler/game/models/shared/card_model.dart';

class CardPileModel {
  final List<CardModel> _cards;

  CardPileModel({int numberOfCards = 0, List<CardModel>? cards})
      : _cards = cards ?? List.generate(
          numberOfCards,
          (index) => CardModel(
            name: 'Card ${index + 1}',
            cost: 1,
            isFaceUp: false,
          ),
        );

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
    
    return drawnCards;
  }

  /// Draws a single card from the top of the pile
  /// Returns null if the pile is empty
  CardModel? drawCard() {
    if (_cards.isEmpty) return null;
    return _cards.removeAt(0);
  }
}