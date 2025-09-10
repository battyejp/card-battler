import 'package:card_battler/game/card_battler_game_new.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class GameScreenNew extends StatelessWidget {
  const GameScreenNew({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: CardBattlerGameNew(),
      ),
    );
  }
}