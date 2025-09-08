/// Service responsible for card UI state management
/// This handles UI-specific logic that doesn't belong in business logic
abstract class CardUIService {
  /// Determines if a button should be enabled based on business rules
  bool isButtonEnabled();
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
}