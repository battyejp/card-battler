import 'package:card_battler/game/models/card/card_model.dart';

/// Service responsible for managing card selection state
/// This separates selection business logic from UI presentation concerns
abstract class CardSelectionService {
  /// Get the currently selected card, if any
  CardModel? get selectedCard;
  
  /// Determines if a specific card is currently selected
  bool isCardSelected(CardModel card);
  
  /// Select a card (deselects any previously selected card)
  void selectCard(CardModel card);
  
  /// Deselect the currently selected card
  void deselectCard();
  
  /// Check if any card is currently selected
  bool get hasSelection;
  
  /// Add listener for selection changes
  void addSelectionListener(void Function(CardModel? selectedCard) listener);
  
  /// Remove listener for selection changes
  void removeSelectionListener(void Function(CardModel? selectedCard) listener);
}

/// Default implementation of CardSelectionService
class DefaultCardSelectionService implements CardSelectionService {
  CardModel? _selectedCard;
  final List<void Function(CardModel?)> _listeners = [];
  
  @override
  CardModel? get selectedCard => _selectedCard;
  
  @override
  bool isCardSelected(CardModel card) => _selectedCard == card;
  
  @override
  void selectCard(CardModel card) {
    if (_selectedCard != card) {
      _selectedCard = card;
      _notifyListeners();
    }
  }
  
  @override
  void deselectCard() {
    if (_selectedCard != null) {
      _selectedCard = null;
      _notifyListeners();
    }
  }
  
  @override
  bool get hasSelection => _selectedCard != null;
  
  @override
  void addSelectionListener(void Function(CardModel?) listener) {
    _listeners.add(listener);
  }
  
  @override
  void removeSelectionListener(void Function(CardModel?) listener) {
    _listeners.remove(listener);
  }
  
  void _notifyListeners() {
    for (final listener in _listeners) {
      try {
        listener(_selectedCard);
      } catch (e) {
        // Continue notifying other listeners even if one fails
      }
    }
  }
  
  /// Reset selection state (useful for testing)
  void reset() {
    _selectedCard = null;
    _listeners.clear();
  }
}