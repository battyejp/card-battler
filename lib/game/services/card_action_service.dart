import 'package:card_battler/game/models/shared/card_model.dart';

class CardActionService {
  void playCard(CardModel card) {
    card.onCardPlayed?.call();
  }

  void setCardPlayedCallback(CardModel card, void Function()? callback) {
    card.onCardPlayed = callback;
  }

  void clearCardPlayedCallback(CardModel card) {
    card.onCardPlayed = null;
  }
}