import 'package:card_battler/game/coordinators/common/reactive_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/stat_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shared/turn_button_component_coordinator.dart';
import 'package:card_battler/game/models/shared/effect_model.dart';
import 'package:card_battler/game/services/card/effects/effect_processor.dart';
import 'package:card_battler/game/services/card/player_card_manager.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';

class PlayerCoordinator with ReactiveCoordinator<PlayerCoordinator> {
  PlayerCoordinator({
    required String name,
    required CardListCoordinator<CardCoordinator> handCardsCoordinator,
    required CardListCoordinator<CardCoordinator> deckCardsCoordinator,
    required CardListCoordinator<CardCoordinator> discardCardsCoordinator,
    required GamePhaseManager gamePhaseManager,
    required EffectProcessor effectProcessor,
    required TurnButtonComponentCoordinator turnButtonComponentCoordinator,
    required StatCoordinator healthStatCoordinator,
    required StatCoordinator creditsStatCoordinator,
    required StatCoordinator attackStatCoordinator,
    this.isActive = false,
  }) : _handCardsCoordinator = handCardsCoordinator,
       _name = name,
       _deckCardsCoordinator = deckCardsCoordinator,
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
       ) {
    _deckCardsCoordinator.shuffle();
  }

  final CardListCoordinator<CardCoordinator> _handCardsCoordinator;
  final CardListCoordinator<CardCoordinator> _deckCardsCoordinator;
  final CardListCoordinator<CardCoordinator> _discardCardsCoordinator;
  final GamePhaseManager _gamePhaseManager;
  final PlayerCardManager _cardManager;
  final TurnButtonComponentCoordinator _turnButtonComponentCoordinator;
  final StatCoordinator _healthStatCoordinator;
  final StatCoordinator _creditsStatCoordinator;
  final StatCoordinator _attackStatCoordinator;
  final String _name;

  CardListCoordinator<CardCoordinator> get handCardsCoordinator =>
      _handCardsCoordinator;
  CardListCoordinator<CardCoordinator> get deckCardsCoordinator =>
      _deckCardsCoordinator;
  CardListCoordinator<CardCoordinator> get discardCardsCoordinator =>
      _discardCardsCoordinator;
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

  void resetCreditsAndAttack() {
    _attackStatCoordinator.resetValue();
    _creditsStatCoordinator.resetValue();
  }

  bool hasAMaxDamageCard() =>
      _handCardsCoordinator.getCardsOfType(EffectType.maxDamage).isNotEmpty;

  int? getMinCardValue(EffectType type) =>
      handCardsCoordinator.getEffectMinValueOfType(type);

  int get attack => _attackStatCoordinator.value;
  int get credits => _creditsStatCoordinator.value;
  int get health => _healthStatCoordinator.value;
  String get name => _name;

  bool isActive;
}
