import 'package:card_battler/game/models/card/card_model.dart';

class CardCoordinator {
  final CardModel _cardModel;

  CardCoordinator(this._cardModel);

  String get name => _cardModel.name;
  bool get isFaceUp => _cardModel.isFaceUp;
}
