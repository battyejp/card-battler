import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/shared/effect_model.dart';
import 'package:card_battler/game/services/card/cards_selection_manager_service.dart';
import 'package:card_battler/game/services/game_state/game_phase_manager.dart';

class CardCoordinator {
  final CardModel cardModel;
  final CardsSelectionManagerService cardsSelectionManagerService;
  final GamePhaseManager gamePhaseManager;

  Function(CardCoordinator)? onCardPlayed;

  CardCoordinator(this.cardModel, this.cardsSelectionManagerService, this.gamePhaseManager);

  String get name => cardModel.name;
  
  bool get isFaceUp => cardModel.isFaceUp;
  set isFaceUp(bool value) => cardModel.isFaceUp = value;

  CardsSelectionManagerService get selectionManagerService => cardsSelectionManagerService;
  List<EffectModel> get effects => cardModel.effects;

  void handleCardPlayed() {
    onCardPlayed?.call(this);
  }
}
