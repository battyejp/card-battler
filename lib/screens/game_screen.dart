import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/card_battler_game.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: CardBattlerGame(),
      ),
    );
  }
}