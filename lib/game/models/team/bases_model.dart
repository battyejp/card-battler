import 'package:card_battler/game/models/team/base_model.dart';

/// Pure game logic for managing a stack of bases
/// Contains no UI dependencies - only manages state and rules
class BasesModel {
  final List<BaseModel> _bases;
  final int _currentBaseIndex;

  BasesModel({
    required int totalBases,
    int baseMaxHealth = 5,
  }) : _bases = List.generate(
          totalBases, 
          (index) => BaseModel(
            name: 'Base ${index + 1}', 
            maxHealth: baseMaxHealth
          )
        ),
        _currentBaseIndex = totalBases - 1;


  /// Gets the current (active) base index
  int get currentBaseIndex => _currentBaseIndex;

  /// Gets the display text for the current state
  String get displayText {
    final allBasesDestroyed = _currentBaseIndex < 0;
    if (allBasesDestroyed) {
      return 'All bases destroyed!';
    }
    final currentBaseNumber = allBasesDestroyed ? 0 : _bases.length - _currentBaseIndex;
    return 'Base $currentBaseNumber of ${_bases.length}';
  }

  /// Gets all bases (including destroyed ones)
  List<BaseModel> get allBases => List.unmodifiable(_bases);
}