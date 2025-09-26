import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/services/ui/card_selection_service.dart';

class CardsSelectionManagerService {
  CardCoordinator? _selectedCard;
  CardSelectionService? _selectionService;

  bool get hasSelection => _selectedCard != null;

  void deselectCard() {
    if (_selectedCard != null) {
      _selectedCard = null;
      _selectionService = null;
    }
  }
}
