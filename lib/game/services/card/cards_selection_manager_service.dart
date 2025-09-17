import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/services/ui/card_selection_service.dart';

class CardsSelectionManagerService {
  CardCoordinator? _selectedCard;
  CardSelectionService? _selectionService;

  CardCoordinator? get selectedCard => _selectedCard;
  CardSelectionService? get selectionService => _selectionService;

  bool isCardSelected(CardCoordinator card) => _selectedCard == card;
  bool get hasSelection => _selectedCard != null;

  void selectCard(CardCoordinator card, CardSelectionService service) {
    if (_selectedCard != card) {
      _selectedCard = card;
      _selectionService = service;
    }
  }

  void deselectCard() {
    if (_selectedCard != null) {
      _selectedCard = null;
      _selectionService = null;
    }
  }
}
