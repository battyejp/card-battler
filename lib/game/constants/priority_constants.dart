/// Constants for managing component rendering priorities (z-index) in the game
/// Higher values render on top of lower values
class PriorityConstants {
  /// Highest priority for selected cards to ensure they always appear on top
  static const int selectedCard = 1000000;
  
  /// Default priority for most components
  static const int default_ = 0;
  
  /// Priority for UI overlays that should appear above normal components but below selected cards
  static const int uiOverlay = 50000;
  
  /// Priority for info components like tooltips and panels
  static const int infoComponent = 10000;
}