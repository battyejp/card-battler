import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/services/card_interaction_service.dart';
import 'package:card_battler/game/services/game_state_service.dart';
import 'package:card_battler/game/services/game_state_manager.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';

void main() {
  group('CardInteractionService', () {
    late GameStateManager gameStateManager;
    late DefaultGameStateService gameStateService;
    late DefaultCardInteractionService cardInteractionService;

    setUp(() {
      gameStateManager = GameStateManager();
      gameStateService = DefaultGameStateService(gameStateManager);
      cardInteractionService = DefaultCardInteractionService(gameStateService);
    });

    tearDown(() {
      gameStateManager.reset();
      GameStateModel.reset();
    });

    group('shouldShowPlayButton', () {
      test('returns false when not in player turn', () {
        // Set to waitingToDrawCards phase
        gameStateManager.reset();
        expect(cardInteractionService.shouldShowPlayButton(), isFalse);
        
        // Move to cardsDrawn phase
        gameStateManager.nextPhase();
        expect(cardInteractionService.shouldShowPlayButton(), isFalse);
        
        // Move to enemyTurn phase
        gameStateManager.nextPhase();
        expect(cardInteractionService.shouldShowPlayButton(), isFalse);
      });

      test('returns true when in player turn', () {
        // Move to playerTurn phase
        gameStateManager.reset();
        gameStateManager.nextPhase(); // waitingToDrawCards -> cardsDrawn
        gameStateManager.nextPhase(); // cardsDrawn -> enemyTurn
        gameStateManager.nextPhase(); // enemyTurn -> playerTurn
        
        expect(cardInteractionService.shouldShowPlayButton(), isTrue);
      });
    });

    group('canPurchaseShopCard', () {
      test('returns false when interactions are disabled', () {
        gameStateManager.reset(); // Not in player turn
        final shopCard = ShopCardModel(name: 'Shop Card', cost: 10);
        
        expect(cardInteractionService.canPurchaseShopCard(shopCard), isFalse);
      });

      test('returns false when player has insufficient credits', () {
        // Move to playerTurn phase
        gameStateManager.reset();
        gameStateManager.nextPhase();
        gameStateManager.nextPhase();
        gameStateManager.nextPhase();
        
        // GameStateModel creates a player with 0 credits by default
        final expensiveCard = ShopCardModel(name: 'Expensive Card', cost: 100);
        expect(cardInteractionService.canPurchaseShopCard(expensiveCard), isFalse);
      });

      test('returns true when player has sufficient credits', () {
        // Move to playerTurn phase  
        gameStateManager.reset();
        gameStateManager.nextPhase();
        gameStateManager.nextPhase();
        gameStateManager.nextPhase();
        
        // Give player some credits
        final player = GameStateModel.instance.selectedPlayer!;
        player.infoModel.credits.changeValue(50);
        
        final affordableCard = ShopCardModel(name: 'Affordable Card', cost: 25);
        expect(cardInteractionService.canPurchaseShopCard(affordableCard), isTrue);
      });
    });
  });
}