import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shared/cards_model.dart';
import 'package:card_battler/game/models/player/info_model.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/services/player/deck_service.dart';
import 'package:card_battler/game/services/player/hand_service.dart';
import 'package:card_battler/game/services/player/discard_service.dart';

/// Coordinator service that orchestrates player card operations between focused services
/// Single responsibility: Coordination and orchestration of player game flow
/// Delegates specific card management tasks to specialized services following SRP
class PlayerCoordinator {
  final PlayerModel state;
  final DeckService deckService;
  final HandService handService;
  final DiscardService discardService;
  
  static const cardsToDrawOnTap = 5;
  
  /// Flag to track if turn is over
  bool turnOver = false;

  PlayerCoordinator({
    required this.state,
    required this.deckService,
    required this.handService,
    required this.discardService,
  }) {
    // Set up the hand service callback
    handService.onCardPlayed = (card) => cardPlayed?.call(card);
  }

  /// External callback for when cards are played
  Function(CardModel)? cardPlayed;

  factory PlayerCoordinator.create({
    required PlayerModel state,
  }) {
    final deckService = DeckService(deckCards: state.deckCards);
    final handService = HandService(handCards: state.handCards);
    final discardService = DiscardService(discardCards: state.discardCards);
    
    return PlayerCoordinator(
      state: state,
      deckService: deckService,
      handService: handService,
      discardService: discardService,
    );
  }

  /// Draws cards from deck following game rules
  void drawCardsFromDeck() {
    if (_shouldPreventDrawing()) {
      return;
    }

    final drawnCards = deckService.drawCards(cardsToDrawOnTap);

    if (drawnCards.length < cardsToDrawOnTap) {
      moveDiscardCardsToDeck();
      final additionalCards = deckService.drawCards(cardsToDrawOnTap - drawnCards.length);
      drawnCards.addAll(additionalCards);
    }

    if (drawnCards.isNotEmpty) {
      handService.addCards(drawnCards);
    }

    state.gameStateService.nextPhase();
  }

  /// Discards all cards in hand to discard pile
  void discardHand() {
    final cardsToDiscard = handService.prepareCardsForDiscard();
    discardService.addCards(cardsToDiscard);
    handService.clearCards();
  }

  /// Moves all discard cards back to deck and shuffles
  void moveDiscardCardsToDeck() {
    if (discardService.hasNoCards) {
      return;
    }

    final discardCards = discardService.removeAllCards();
    deckService.addCardsAndShuffle(discardCards);
  }

  /// Checks if drawing should be prevented
  bool _shouldPreventDrawing() {
    return (state.cardSelectionService.hasSelection) || handService.hasCards;
  }


  // Expose state properties for external access
  InfoModel get infoModel => state.infoModel;
  
  // Expose the original CardsModel instances for backward compatibility
  // The services work with these models internally
  CardsModel<CardModel> get handCards => state.handCards;
  CardsModel<CardModel> get deckCards => state.deckCards;
  CardsModel<CardModel> get discardCards => state.discardCards;
}