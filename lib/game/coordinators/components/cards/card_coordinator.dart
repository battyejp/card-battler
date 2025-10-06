import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/shared/play_effects_model.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';

class CardCoordinator {
  CardCoordinator({
    required CardModel cardModel,
    required GamePhaseManager gamePhaseManager,
    required ActivePlayerManager activePlayerManager,
  }) : _cardModel = cardModel,
       _gamePhaseManager = gamePhaseManager,
       _activePlayerManager = activePlayerManager;

  final CardModel _cardModel;
  final GamePhaseManager _gamePhaseManager;
  final ActivePlayerManager _activePlayerManager;

  Function(CardCoordinator)? onCardPlayed;

  String get name => _cardModel.name;
  String get filename => _cardModel.filename;
  CardType get type => _cardModel.type;

  bool get isFaceUp => _cardModel.isFaceUp;
  set isFaceUp(bool value) => _cardModel.isFaceUp = value;
  EffectsModel get playEffects => _cardModel.playEffects;
  EffectsModel get handEffects => _cardModel.handEffects;

  GamePhaseManager get gamePhaseManager => _gamePhaseManager;

  ActivePlayerManager get activePlayerManager => _activePlayerManager;

  void handleCardPlayed() {
    onCardPlayed?.call(this);
  }
}
