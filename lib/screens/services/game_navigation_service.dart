import 'package:card_battler/game/card_battler_game.dart';

/// Service responsible for handling game navigation between different scenes
///
/// This service encapsulates all navigation logic, separating it from UI state
/// management in the GameScreen overlay.
class GameNavigationService {
  GameNavigationService(this._game);

  final CardBattlerGame _game;

  /// Navigate to the shop scene
  void navigateToShop() {
    _game.router.pushNamed('shop');
  }

  /// Navigate back from the shop to the game scene
  void navigateBackFromShop() {
    _game.router.pop();
  }

  /// Pop the current route (generic navigation back)
  void goBack() {
    _game.router.pop();
  }
}
