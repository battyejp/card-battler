import 'package:card_battler/game/models/enemy/enemies_model.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/player/player_turn_state.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shop/shop_model.dart';
import 'package:card_battler/game/models/team/team_model.dart';
import 'package:card_battler/game/services/card/card_play_orchestrator.dart';
import 'package:card_battler/game/services/card/effect_processor.dart';
import 'package:card_battler/game/services/game_state/game_state_service.dart';
import 'package:card_battler/game/services/turn/turn_manager.dart';

/// Coordinator service that manages player turn operations
/// This replaces the PlayerTurnModel and delegates responsibilities to specialized services
/// Follows the Single Responsibility Principle by focusing on coordination rather than implementation
class PlayerTurnCoordinator {
  final PlayerTurnState state;
  final CardPlayOrchestrator _cardPlayOrchestrator;
  final EffectProcessor _effectProcessor;
  final TurnManager _turnManager;

  PlayerTurnCoordinator({
    required this.state,
    required GameStateService gameStateService,
    CardPlayOrchestrator? cardPlayOrchestrator,
    EffectProcessor? effectProcessor,
    TurnManager? turnManager,
  })  : _cardPlayOrchestrator = cardPlayOrchestrator ?? DefaultCardPlayOrchestrator(),
        _effectProcessor = effectProcessor ?? DefaultEffectProcessor(),
        _turnManager = turnManager ?? DefaultTurnManager(gameStateService) {
    // Set up card played callbacks
    state.playerModel.cardPlayed = onCardPlayed;
    state.shopModel.cardPlayed = onCardPlayed;
  }

  // Expose state properties for backward compatibility
  PlayerModel get playerModel => state.playerModel;
  TeamModel get teamModel => state.teamModel;
  EnemiesModel get enemiesModel => state.enemiesModel;
  ShopModel get shopModel => state.shopModel;

  /// Handles when a card is played - delegates to the card play orchestrator
  void onCardPlayed(CardModel card) {
    _cardPlayOrchestrator.playCard(card, state, _effectProcessor);
  }

  /// Discards all cards from hand - delegates to turn manager
  void discardHand() {
    _turnManager.discardHand(state);
  }

  /// Applies card effects - delegates to effect processor
  void applyCardEffects(CardModel card) {
    _effectProcessor.applyCardEffects(card, state);
  }

  /// Ends the current turn - delegates to turn manager
  void endTurn() {
    _turnManager.endTurn(state);
  }

  /// Handles turn button press - delegates to turn manager
  void handleTurnButtonPress() {
    _turnManager.handleTurnButtonPress(state);
  }
}