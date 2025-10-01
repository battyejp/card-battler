import 'package:card_battler/game/card_battler_game.dart';
import 'package:card_battler/screens/services/game_navigation_service.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = CardBattlerGame();
    final navigationService = GameNavigationService(game);

    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: game),
          GameOverlay(navigationService: navigationService),
        ],
      ),
    );
  }
}

class GameOverlay extends StatefulWidget {
  const GameOverlay({required this.navigationService, super.key});
  final GameNavigationService navigationService;

  @override
  State<GameOverlay> createState() => _GameOverlayState();
}

class _GameOverlayState extends State<GameOverlay> {
  bool _isInShop = false;

  void _toggleView() {
    setState(() {
      _isInShop = !_isInShop;
    });

    if (_isInShop) {
      widget.navigationService.navigateToShop();
    } else {
      widget.navigationService.navigateBackFromShop();
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, size: 20),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withAlpha(179),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(0),
                ),
              ),
              IconButton(
                onPressed: _toggleView,
                icon: Icon(_isInShop ? Icons.gamepad : Icons.shop_2, size: 20),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withAlpha(179),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(0),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
