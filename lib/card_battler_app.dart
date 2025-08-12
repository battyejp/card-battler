import 'package:flutter/material.dart';
import 'screens/loading_screen.dart';

class CardBattlerApp extends StatelessWidget {
  const CardBattlerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Battler',
      theme: ThemeData.dark(),
      home: const LoadingScreen(),
    );
  }
}