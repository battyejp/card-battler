import 'package:flutter_test/flutter_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:card_battler/game/components/shop/shop_card.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/services/card_selection_service.dart';
import 'package:card_battler/game/constants/priority_constants.dart';

// Mock TapUpEvent that includes the local position directly
class MockTapUpEvent extends TapUpEvent {
  final Vector2 _mockLocalPosition;
  
  MockTapUpEvent(int pointerId, Game game, this._mockLocalPosition)
      : super(pointerId, game, TapUpDetails(kind: PointerDeviceKind.touch));
  
  @override
  Vector2 get localPosition => _mockLocalPosition;
}

void main() {
  group('Shop Card Priority Tests', () {
    late ShopCard shopCard;
    late ShopCardModel shopCardModel;
    late CardSelectionService cardSelectionService;

    setUp(() {
      shopCardModel = ShopCardModel(name: 'Test Shop Card', cost: 5);
      cardSelectionService = DefaultCardSelectionService();
      shopCard = ShopCard(
        shopCardModel,
        cardSelectionService: cardSelectionService,
      );
    });

    testWithFlameGame('shop card gets highest priority when selected', (game) async {
      shopCard.size = Vector2(100, 150);
      shopCard.priority = 5; // Set initial priority
      await game.ensureAdd(shopCard);
      
      expect(shopCard.priority, equals(5)); // Initial priority
      
      // Select the shop card using tap event
      final tapEvent = MockTapUpEvent(1, game, Vector2.zero());
      shopCard.onTapUp(tapEvent);
      
      // Complete selection animation
      game.update(1.0);
      
      // Should now have the highest priority
      expect(shopCard.priority, equals(PriorityConstants.selectedCard));
      expect(shopCard.priority, greaterThan(999999)); // Ensure it's higher than old value
      
      // Clean up
      cardSelectionService.deselectCard();
      game.update(1.0);
    });

    testWithFlameGame('shop card priority is restored after deselection', (game) async {
      shopCard.size = Vector2(100, 150);
      shopCard.priority = 10; // Set initial priority
      await game.ensureAdd(shopCard);
      
      // Select card
      final tapEvent = MockTapUpEvent(1, game, Vector2.zero());
      shopCard.onTapUp(tapEvent);
      game.update(1.0);
      
      expect(shopCard.priority, equals(PriorityConstants.selectedCard));
      
      // Deselect card
      cardSelectionService.deselectCard();
      game.update(1.0);
      
      // Priority should be restored to original value
      expect(shopCard.priority, equals(10));
    });

    testWithFlameGame('selected shop card priority is higher than info components', (game) async {
      shopCard.size = Vector2(100, 150);
      await game.ensureAdd(shopCard);
      
      // Select the shop card
      final tapEvent = MockTapUpEvent(1, game, Vector2.zero());
      shopCard.onTapUp(tapEvent);
      game.update(1.0);
      
      // Verify priority is higher than any info component priority
      expect(shopCard.priority, greaterThan(PriorityConstants.infoComponent));
      expect(shopCard.priority, greaterThan(PriorityConstants.uiOverlay));
      expect(shopCard.priority, equals(PriorityConstants.selectedCard));
      
      // Clean up
      cardSelectionService.deselectCard();
      game.update(1.0);
    });
  });
}