import 'package:card_battler/game_legacy/models/shared/card_model.dart';
import 'package:card_battler/game_legacy/models/shared/reactive_model.dart';
import 'package:card_battler/game_legacy/models/shop/shop_card_model.dart';
import 'package:card_battler/game_legacy/models/shop/shop_model.dart';

/// Coordinator service that manages shop operations
/// This replaces the business logic from ShopModel and delegates responsibilities to specialized services
/// Follows the Single Responsibility Principle by focusing on coordination rather than implementation
class ShopCoordinator with ReactiveModel<ShopCoordinator> {
  final ShopModel state;

  /// External callback for when cards are played
  Function(CardModel)? cardPlayed;

  ShopCoordinator({
    required this.state,
  }) {
    // Set up the card played callback to forward to our public callback
    state.cardHandler.setCardPlayedCallback((card) => cardPlayed?.call(card));
    
    // Initialize the shop with cards from inventory
    final initialCards = state.inventory.drawCards(state.layout.displayCount);
    state.cardHandler.setupCardCallbacks(initialCards);
    state.display.addCards(initialCards);
    
    // Listen to display changes and forward them
    state.display.changes.listen((_) => notifyChange());
  }

  factory ShopCoordinator.create({
    required int numberOfRows,
    required int numberOfColumns,
    required List<ShopCardModel> cards,
  }) {
    final state = ShopModel.create(
      numberOfRows: numberOfRows,
      numberOfColumns: numberOfColumns,
      cards: cards,
    );
    
    return ShopCoordinator(state: state);
  }

  /// Removes a selectable card from the shop display
  void removeSelectableCardFromShop(ShopCardModel card) {
    state.display.removeCard(card);
  }

  /// Refills the shop with cards from inventory
  void refillShop() {
    final emptySlots = state.display.getEmptySlots(state.layout.displayCount);
    
    if (emptySlots == 0) {
      return;
    }

    final newCards = state.inventory.drawCards(emptySlots);
    state.cardHandler.setupCardCallbacks(newCards);
    state.display.addCards(newCards);
  }

  // Expose state properties for external access
  List<ShopCardModel> get selectableCards => state.display.displayedCards;
  int get numberOfRows => state.layout.numberOfRows;
  int get numberOfColumns => state.layout.numberOfColumns;
}