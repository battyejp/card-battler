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
}