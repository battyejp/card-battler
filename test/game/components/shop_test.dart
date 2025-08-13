import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/shop.dart';
import 'package:card_battler/game/components/card.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  testWithFlameGame('Shop adds 6 Card components', (game) async {
    final shop = Shop()..size = Vector2(300, 200);
    await game.ensureAdd(shop);
    expect(shop.children.whereType<Card>().length, 6);
  });
}
