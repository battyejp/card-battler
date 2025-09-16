import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';

class CardsSelectionManagerService {
  CardCoordinator? _selectedCard;

  CardCoordinator? get selectedCard => _selectedCard;
  bool isCardSelected(CardCoordinator card) => _selectedCard == card;
  bool get hasSelection => _selectedCard != null;

  void selectCard(CardCoordinator card) {
    if (_selectedCard != card) {
      _selectedCard = card;
    }
  }

  void deselectCard() {
    if (_selectedCard != null) {
      _selectedCard = null;
    }
  }
}
