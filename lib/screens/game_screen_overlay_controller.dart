import 'package:card_battler/screens/services/game_navigation_service.dart';

class GameScreenOverlayController {
  GameScreenOverlayController(this._navigationService);

  final GameNavigationService _navigationService;
  bool _isInShop = false;

  bool get isInShop => _isInShop;

  void toggleView() {
    _isInShop = !_isInShop;
    if (_isInShop) {
      _navigationService.navigateToShop();
    } else {
      _navigationService.navigateBackFromShop();
    }
  }
}
