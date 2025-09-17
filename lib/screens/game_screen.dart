import 'package:card_battler/game/card_battler_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: GameWidget(game: CardBattlerGame()));
}
