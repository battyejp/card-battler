import 'package:card_battler/game/models/shared/cards_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/player/info_model.dart';
import 'package:card_battler/game/models/player/player_state.dart';
import 'package:card_battler/game/services/player/player_coordinator.dart';
import 'package:card_battler/game/services/game_state/game_state_service.dart';
import 'package:card_battler/game/services/card/card_selection_service.dart';

/// Refactored PlayerModel that now delegates to PlayerCoordinator
/// Maintains backward compatibility while following Single Responsibility Principle
/// This class now acts as a facade to the new PlayerCoordinator architecture
class PlayerModel {
  final PlayerCoordinator _coordinator;
  
  static const cardsToDrawOnTap = 5;

  PlayerModel({
    required InfoModel infoModel,
    required CardsModel<CardModel> handModel,
    required CardsModel<CardModel> deckModel,
    required CardsModel<CardModel> discardModel,
    required GameStateService gameStateService,
    required CardSelectionService cardSelectionService,
  }) : _coordinator = PlayerCoordinator.create(
    state: PlayerState.create(
      infoModel: infoModel,
      handModel: handModel,
      deckModel: deckModel,
      discardModel: discardModel,
      gameStateService: gameStateService,
      cardSelectionService: cardSelectionService,
    ),
  );

  // Expose models for use in the game components (delegated to coordinator)
  InfoModel get infoModel => _coordinator.infoModel;
  CardsModel<CardModel> get handCards => _coordinator.handCards;
  CardsModel<CardModel> get deckCards => _coordinator.deckCards;
  CardsModel<CardModel> get discardCards => _coordinator.discardCards;
  
  // Delegate cardPlayed callback to coordinator
  Function(CardModel)? get cardPlayed => _coordinator.cardPlayed;
  set cardPlayed(Function(CardModel)? value) => _coordinator.cardPlayed = value;
  
  // Delegate turnOver flag to coordinator
  bool get turnOver => _coordinator.turnOver;
  set turnOver(bool value) => _coordinator.turnOver = value;

  // Delegate all business operations to coordinator
  void drawCardsFromDeck() {
    _coordinator.drawCardsFromDeck();
  }

  void discardHand() {
    _coordinator.discardHand();
  }

  void moveDiscardCardsToDeck() {
    _coordinator.moveDiscardCardsToDeck();
  }
}
