import 'package:card_battler/game/models/enemy/enemies_model.dart';
import 'package:card_battler/game/services/player/player_coordinator.dart';
import 'package:card_battler/game/models/player/player_turn_state.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/services/shop/shop_coordinator.dart';
import 'package:card_battler/game/models/team/team_model.dart';
import 'package:card_battler/game/services/card/card_play_orchestrator.dart';
import 'package:card_battler/game/services/playerTurn/player_effect_processor.dart';
import 'package:card_battler/game/services/game_state/game_state_service.dart';
import 'package:card_battler/game/services/playerTurn/player_turn_manager.dart';

/// Coordinator service that manages player turn operations
/// This replaces the PlayerTurnModel and delegates responsibilities to specialized services
/// Follows the Single Responsibility Principle by focusing on coordination rather than implementation
class PlayerTurnCoordinator {
  final PlayerTurnState state;
  final CardPlayOrchestrator _cardPlayOrchestrator;
  final PlayerEffectProcessor _effectProcessor;
  final PlayerTurnManager _turnManager;

  PlayerTurnCoordinator({
    required this.state,
    required GameStateService gameStateService,
    CardPlayOrchestrator? cardPlayOrchestrator,
    PlayerEffectProcessor? effectProcessor,
    PlayerTurnManager? turnManager,
  })  : _cardPlayOrchestrator = cardPlayOrchestrator ?? DefaultCardPlayOrchestrator(),
        _effectProcessor = effectProcessor ?? DefaultPlayerEffectProcessor(),
        _turnManager = turnManager ?? DefaultPlayerTurnManager(gameStateService) {
    // Set up card played callbacks
    state.playerModel.cardPlayed = onCardPlayed;
    state.shopModel.cardPlayed = onCardPlayed;
  }

  // Expose state properties for backward compatibility
  PlayerCoordinator get playerModel => state.playerModel;
  TeamModel get teamModel => state.teamModel;
  EnemiesModel get enemiesModel => state.enemiesModel;
  ShopCoordinator get shopModel => state.shopModel;

  /// Handles when a card is played - delegates to the card play orchestrator
  void onCardPlayed(CardModel card) {
    _cardPlayOrchestrator.playCard(card, state, _effectProcessor);
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