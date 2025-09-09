
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shared/cards_model.dart';
import 'package:card_battler/game/models/team/players_model.dart';
import 'package:card_battler/game/models/enemy/enemy_turn_state.dart';
import 'package:card_battler/game/services/game_state/game_state_service.dart';
import 'package:card_battler/game/services/enemy/enemy_turn_manager.dart';
import 'package:card_battler/game/services/enemy/enemy_effect_processor.dart';
import 'package:card_battler/game/services/enemy/enemy_card_draw_service.dart';

/// Refactored EnemyTurnCoordinator following SRP principles
/// Now acts as a lightweight coordinator using dedicated services
class EnemyTurnCoordinator {
  final EnemyTurnState _state;
  final DefaultEnemyTurnManager _turnManager;
  final EnemyEffectProcessor _effectProcessor;
  final EnemyCardDrawService _cardDrawService;

  EnemyTurnCoordinator._internal({
    required EnemyTurnState state,
    required DefaultEnemyTurnManager turnManager,
    required EnemyEffectProcessor effectProcessor,
    required EnemyCardDrawService cardDrawService,
  }) : _state = state,
       _turnManager = turnManager,
       _effectProcessor = effectProcessor,
       _cardDrawService = cardDrawService {
    _state.enemyCards.shuffle();
  }

  factory EnemyTurnCoordinator({
    required CardsModel<CardModel> enemyCards,
    required PlayersModel playersModel,
    required GameStateService gameStateService,
    EnemyTurnManager? turnManager,
    EnemyEffectProcessor? effectProcessor,
    EnemyCardDrawService? cardDrawService,
  }) {
    final state = EnemyTurnState(
      enemyCards: enemyCards,
      playedCards: CardsModel<CardModel>.empty(),
      playersModel: playersModel,
      gameStateService: gameStateService,
    );
    
    final turnMgr = (turnManager as DefaultEnemyTurnManager?) ?? DefaultEnemyTurnManager();
    final effectProc = effectProcessor ?? DefaultEnemyEffectProcessor();
    final cardDrawSvc = cardDrawService ?? DefaultEnemyCardDrawService(turnMgr);
    
    return EnemyTurnCoordinator._internal(
      state: state,
      turnManager: turnMgr,
      effectProcessor: effectProc,
      cardDrawService: cardDrawSvc,
    );
  }

  void drawCardsFromDeck() {
    final drawnCard = _cardDrawService.drawCard(_state);
    
    if (drawnCard != null) {
      _effectProcessor.processCardEffects(drawnCard, _state);
    }

    if (_turnManager.isTurnFinished) {
      _turnManager.completeTurn(_state);
    }
  }

  void resetTurn() {
    _turnManager.resetTurn();
  }

  // TODO See if these can be removed 
  // Expose state and effect processor for test access
  CardsModel<CardModel> get enemyCards => _state.enemyCards;
  CardsModel<CardModel> get playedCards => _state.playedCards;
  PlayersModel get playersModel => _state.playersModel;
}