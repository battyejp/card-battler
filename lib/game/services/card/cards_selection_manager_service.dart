import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';

//TODO make this a proper service with DI
class CardsSelectionManagerService {
  // Private constructor
  CardsSelectionManagerService._();

  // Static instance variable
  static final CardsSelectionManagerService _instance =
      CardsSelectionManagerService._();

  // Public getter for the singleton instance
  static CardsSelectionManagerService get instance => _instance;

  // Factory constructor that returns the singleton instance
  factory CardsSelectionManagerService() => _instance;

  CardCoordinator? _selectedCard;
  //final List<void Function(CardModel?)> _listeners = [];

  CardCoordinator? get selectedCard => _selectedCard;

  bool isCardSelected(CardCoordinator card) => _selectedCard == card;

  void selectCard(CardCoordinator card) {
    if (_selectedCard != card) {
      _selectedCard = card;
      //_notifyListeners();
    }
  }

  void deselectCard() {
    if (_selectedCard != null) {
      _selectedCard = null;
      //_notifyListeners();
    }
  }

  bool get hasSelection => _selectedCard != null;

  // void addSelectionListener(void Function(CardModel?) listener) {
  //   _listeners.add(listener);
  // }

  // void removeSelectionListener(void Function(CardModel?) listener) {
  //   _listeners.remove(listener);
  // }

  // void _notifyListeners() {
  //   for (final listener in _listeners) {
  //     try {
  //       listener(_selectedCard);
  //     } catch (e) {
  //       // Continue notifying other listeners even if one fails
  //     }
  //   }
  // }

  // void reset() {
  //   _selectedCard = null;
  //   _listeners.clear();
  // }
}
