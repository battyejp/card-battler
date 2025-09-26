import 'package:card_battler/game/card_battler_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = CardBattlerGame();

    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: game),
          GameOverlay(game: game),
        ],
      ),
    );
  }
}

class GameOverlay extends StatefulWidget {
  const GameOverlay({required this.game, super.key});
  final CardBattlerGame game;

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
      widget.game.router.pushNamed('shop');
    } else {
      widget.game.router.pop();
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
