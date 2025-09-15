import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/shared/effect_model.dart';
import 'package:card_battler/game/services/card/cards_selection_manager_service.dart';
import 'package:card_battler/game/services/game_state/game_phase_manager.dart';
import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';

class CardCoordinator {
  final CardModel _cardModel;
  final CardsSelectionManagerService _cardsSelectionManagerService;
  final GamePhaseManager _gamePhaseManager;

  Function(CardCoordinator)? onCardPlayed;

  CardCoordinator({required CardModel cardModel, required CardsSelectionManagerService cardsSelectionManagerService, required GamePhaseManager gamePhaseManager})
      : _cardModel = cardModel,
        _cardsSelectionManagerService = cardsSelectionManagerService,
        _gamePhaseManager = gamePhaseManager;

  String get name => _cardModel.name;

  bool get isFaceUp => _cardModel.isFaceUp;
  set isFaceUp(bool value) => _cardModel.isFaceUp = value;

  CardsSelectionManagerService get selectionManagerService => _cardsSelectionManagerService;
  List<EffectModel> get effects => _cardModel.effects;

  GamePhaseManager get gamePhaseManager => _gamePhaseManager;

  void handleCardPlayed() {
    onCardPlayed?.call(this);
  }

  bool isActionDisabled(PlayerInfoCoordinator playerInfoCoordinator) {
    return false;
  }
}
