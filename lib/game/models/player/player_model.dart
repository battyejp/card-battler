import 'package:card_battler/game/models/shared/cards_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/player/info_model.dart';
import 'package:card_battler/game/services/game_state/game_state_service.dart';
import 'package:card_battler/game/services/card/card_selection_service.dart';

/// Simple data holder for player state
/// Contains only the player components needed without any behavior
/// This class follows the Single Responsibility Principle by focusing solely on data storage
class PlayerModel {
  final InfoModel infoModel;
  final CardsModel<CardModel> handCards;
  final CardsModel<CardModel> deckCards;
  final CardsModel<CardModel> discardCards;
  final GameStateService gameStateService;
  final CardSelectionService cardSelectionService;

  const PlayerModel({
    required this.infoModel,
    required this.handCards,
    required this.deckCards,
    required this.discardCards,
    required this.gameStateService,
    required this.cardSelectionService,
  });

  factory PlayerModel.create({
    required InfoModel infoModel,
    required CardsModel<CardModel> handModel,
    required CardsModel<CardModel> deckModel,
    required CardsModel<CardModel> discardModel,
    required GameStateService gameStateService,
    required CardSelectionService cardSelectionService,
  }) {
    // Initialize deck with shuffle
    deckModel.shuffle();
    
    return PlayerModel(
      infoModel: infoModel,
      handCards: handModel,
      deckCards: deckModel,
      discardCards: discardModel,
      gameStateService: gameStateService,
      cardSelectionService: cardSelectionService,
    );
  }
}