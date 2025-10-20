import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/stat_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shared/turn_button_component_coordinator.dart';
import 'package:card_battler/game/services/card/effects/effect_processor.dart';
import 'package:card_battler/game/services/card/player_card_manager.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';

class PlayerCoordinator {
  PlayerCoordinator({
    required CardListCoordinator<CardCoordinator> handCardsCoordinator,
    required CardListCoordinator<CardCoordinator> deckCardsCoordinator,
    required CardListCoordinator<CardCoordinator> discardCardsCoordinator,
    required PlayerInfoCoordinator playerInfoCoordinator,
    required GamePhaseManager gamePhaseManager,
    required EffectProcessor effectProcessor,
    required TurnButtonComponentCoordinator turnButtonComponentCoordinator,
    required StatCoordinator healthStatCoordinator,
    required StatCoordinator creditsStatCoordinator,
    required StatCoordinator attackStatCoordinator,
  }) : _handCardsCoordinator = handCardsCoordinator,
       _deckCardsCoordinator = deckCardsCoordinator,
       _playerInfoCoordinator = playerInfoCoordinator,
       _discardCardsCoordinator = discardCardsCoordinator,
       _gamePhaseManager = gamePhaseManager,
       _healthStatCoordinator = healthStatCoordinator,
       _creditsStatCoordinator = creditsStatCoordinator,
        _attackStatCoordinator = attackStatCoordinator,
       _turnButtonComponentCoordinator = turnButtonComponentCoordinator,
       _cardManager = PlayerCardManager(
         handCardsCoordinator: handCardsCoordinator,
         deckCardsCoordinator: deckCardsCoordinator,
         discardCardsCoordinator: discardCardsCoordinator,
         gamePhaseManager: gamePhaseManager,
         effectProcessor: effectProcessor,
         playerInfoCoordinator: playerInfoCoordinator,
       ) {
    _deckCardsCoordinator.shuffle();
  }

  final CardListCoordinator<CardCoordinator> _handCardsCoordinator;
  final CardListCoordinator<CardCoordinator> _deckCardsCoordinator;
  final CardListCoordinator<CardCoordinator> _discardCardsCoordinator;
  final PlayerInfoCoordinator _playerInfoCoordinator;
  final GamePhaseManager _gamePhaseManager;
  final PlayerCardManager _cardManager;
  final TurnButtonComponentCoordinator _turnButtonComponentCoordinator;
  final StatCoordinator _healthStatCoordinator;
  final StatCoordinator _creditsStatCoordinator;
  final StatCoordinator _attackStatCoordinator;

  CardListCoordinator<CardCoordinator> get handCardsCoordinator =>
      _handCardsCoordinator;
  CardListCoordinator<CardCoordinator> get deckCardsCoordinator =>
      _deckCardsCoordinator;
  CardListCoordinator<CardCoordinator> get discardCardsCoordinator =>
      _discardCardsCoordinator;
  PlayerInfoCoordinator get playerInfoCoordinator => _playerInfoCoordinator;
  GamePhaseManager get gamePhaseManager => _gamePhaseManager;
  TurnButtonComponentCoordinator get turnButtonComponentCoordinator =>
      _turnButtonComponentCoordinator;
  StatCoordinator get healthStatCoordinator => _healthStatCoordinator;
  StatCoordinator get creditsStatCoordinator => _creditsStatCoordinator;
  StatCoordinator get attackStatCoordinator => _attackStatCoordinator;

  void drawCardsFromDeck(int numberOfCards) {
    _cardManager.drawCardsFromDeck(numberOfCards);
  }

  void adjustHealth(int amount) {
    _healthStatCoordinator.adjustValue(amount);
  }

  void adjustCredits(int amount) {
    _creditsStatCoordinator.adjustValue(amount);
  }

  void adjustAttack(int amount) {
    _attackStatCoordinator.adjustValue(amount);
  }
}
