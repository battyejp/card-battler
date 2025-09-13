import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/shared/effect_model.dart';
import 'package:card_battler/game/services/card/cards_selection_manager_service.dart';
import 'package:card_battler/game/services/game_state/game_phase_manager.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';

class CardCoordinator {
  final CardModel _cardModel;
  final CardsSelectionManagerService cardsSelectionManagerService;
  final GamePhaseManager gamePhaseManager;

  CardCoordinator(this._cardModel, this.cardsSelectionManagerService, this.gamePhaseManager);

  String get name => _cardModel.name;
  
  bool get isFaceUp => _cardModel.isFaceUp;
  set isFaceUp(bool value) => _cardModel.isFaceUp = value;

  CardsSelectionManagerService get selectionManagerService => cardsSelectionManagerService;
  List<EffectModel> get effects => _cardModel.effects;
}
