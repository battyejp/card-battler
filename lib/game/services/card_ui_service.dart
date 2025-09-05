/// Service responsible for card UI state management
/// This handles UI-specific logic that doesn't belong in business logic
abstract class CardUIService {
  /// Determines if a button should be enabled based on business rules
  bool isButtonEnabled();
  
  /// Determines if interactions should be allowed based on UI state
  bool areInteractionsAllowed();
}

/// Implementation that delegates to business logic services
class DefaultCardUIService implements CardUIService {
  final bool Function()? _businessLogicCheck;
  
  DefaultCardUIService({bool Function()? businessLogicCheck}) 
    : _businessLogicCheck = businessLogicCheck;
  
  @override
  bool isButtonEnabled() {
    return _businessLogicCheck?.call() ?? true;
  }
  
  //TODO is this needed?
  @override
  bool areInteractionsAllowed() {
    // UI-specific rules for allowing interactions
    // (e.g., not during animations, not if already selected, etc.)
    return true;
  }
}