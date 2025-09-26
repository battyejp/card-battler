import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/shared/effect_model.dart';
import 'package:card_battler/game/services/card/cards_selection_manager_service.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';

class CardCoordinator {
  CardCoordinator({
    required CardModel cardModel,
    required CardsSelectionManagerService cardsSelectionManagerService,
    required GamePhaseManager gamePhaseManager,
    required ActivePlayerManager activePlayerManager,
  }) : _cardModel = cardModel,
       _cardsSelectionManagerService = cardsSelectionManagerService,
       _gamePhaseManager = gamePhaseManager,
       _activePlayerManager = activePlayerManager;

  final CardModel _cardModel;
  final CardsSelectionManagerService _cardsSelectionManagerService;
  final GamePhaseManager _gamePhaseManager;
  final ActivePlayerManager _activePlayerManager;

  Function(CardCoordinator)? onCardPlayed;

  String get name => _cardModel.name;
  String get filename => _cardModel.filename;
  String get type => _cardModel.type;

  bool get isFaceUp => _cardModel.isFaceUp;
  set isFaceUp(bool value) => _cardModel.isFaceUp = value;

  CardsSelectionManagerService get selectionManagerService =>
      _cardsSelectionManagerService;
  List<EffectModel> get effects => _cardModel.effects;

  GamePhaseManager get gamePhaseManager => _gamePhaseManager;

  ActivePlayerManager get activePlayerManager => _activePlayerManager;

  void handleCardPlayed() {
    onCardPlayed?.call(this);
  }
}
