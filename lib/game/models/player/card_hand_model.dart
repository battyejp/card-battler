import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shared/reactive_model.dart';

class CardHandModel with ReactiveModel<CardHandModel> {
  final List<CardModel> _cards;

  CardHandModel() : _cards = [];

  List<CardModel> get cards => _cards;

  /// Adds cards to the hand
  void addCards(List<CardModel> newCards) {
    _cards.addAll(newCards);
    notifyChange();
  }

  /// Adds a single card to the hand
  void addCard(CardModel card) {
    _cards.add(card);
    notifyChange();
  }

  /// Clears all cards from the hand
  void clearCards() {
    _cards.clear();
    notifyChange();
  }

  /// Replaces all cards in the hand with new ones
  void replaceCards(List<CardModel> newCards) {
    _cards.clear();
    _cards.addAll(newCards);
    notifyChange();
  }
}