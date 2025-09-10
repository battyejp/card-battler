/// Manages shop grid layout configuration
/// Single responsibility: Layout configuration management
class ShopLayout {
  final int _numberOfRows;
  final int _numberOfColumns;
  final int _displayCount;

  ShopLayout({
    required int numberOfRows,
    required int numberOfColumns,
  }) : _numberOfRows = numberOfRows,
       _numberOfColumns = numberOfColumns,
       _displayCount = numberOfRows * numberOfColumns;

  /// Gets the number of rows in the shop grid
  int get numberOfRows => _numberOfRows;

  /// Gets the number of columns in the shop grid
  int get numberOfColumns => _numberOfColumns;

  /// Gets the total number of display slots
  int get displayCount => _displayCount;
}