import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/services/card/cards_selection_manager_service.dart';

class CardCoordinator {
  final CardModel _cardModel;
  final CardsSelectionManagerService cardsSelectionManagerService;

  CardCoordinator(this._cardModel, this.cardsSelectionManagerService);

  String get name => _cardModel.name;
  
  bool get isFaceUp => _cardModel.isFaceUp;
  set isFaceUp(bool value) => _cardModel.isFaceUp = value;

  CardsSelectionManagerService get selectionManagerService => cardsSelectionManagerService;
}
