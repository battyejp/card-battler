import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';
import 'package:card_battler/game/models/card/card_list_model.dart';
import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/shared/effect_model.dart';
import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/services/card/cards_selection_manager_service.dart';
import 'package:card_battler/game/services/card/effects/effect_processor.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';
import 'package:mocktail/mocktail.dart';

/// Mock classes for commonly tested services and models
class MockCardModel extends Mock implements CardModel {}
class MockCardsSelectionManagerService extends Mock implements CardsSelectionManagerService {}
class MockGamePhaseManager extends Mock implements GamePhaseManager {}
class MockActivePlayerManager extends Mock implements ActivePlayerManager {}
class MockEffectProcessor extends Mock implements EffectProcessor {}
class MockPlayerCoordinator extends Mock implements PlayerCoordinator {}
class MockPlayerInfoCoordinator extends Mock implements PlayerInfoCoordinator {}

/// Helper utilities for creating mock objects with common configurations
class MockHelpers {
  /// Creates a CardModel mock with default configurations
  static MockCardModel createMockCard({
    String name = 'Test Card',
    String type = 'action',
    bool isFaceUp = true,
    List<EffectModel> effects = const [],
  }) {
    final mock = MockCardModel();
    when(() => mock.name).thenReturn(name);
    when(() => mock.type).thenReturn(type);
    when(() => mock.isFaceUp).thenReturn(isFaceUp);
    when(() => mock.effects).thenReturn(effects);
    when(() => mock.copy()).thenReturn(mock); // Return self for copy
    return mock;
  }

  /// Creates a HealthModel for testing
  static HealthModel createHealthModel({
    int currentHealth = 100,
    int maxHealth = 150,
  }) {
    return HealthModel(currentHealth, maxHealth);
  }

  /// Creates a PlayerModel for testing
  static PlayerModel createTestPlayer({
    String name = 'Test Player',
    int health = 100,
    int maxHealth = 150,
    List<CardModel> deckCards = const [],
    bool isActive = false,
    int credits = 0,
    int attack = 0,
  }) {
    return PlayerModel(
      name: name,
      healthModel: HealthModel(health, maxHealth),
      handCards: CardListModel(cards: []),
      deckCards: CardListModel(cards: deckCards),
      discardCards: CardListModel(cards: []),
      isActive: isActive,
      credits: credits,
      attack: attack,
    );
  }

  /// Creates common effect models for testing
  static List<EffectModel> createTestEffects() {
    return [
      EffectModel(
        type: EffectType.attack,
        target: EffectTarget.activePlayer,
        value: 10,
      ),
      EffectModel(
        type: EffectType.heal,
        target: EffectTarget.self,
        value: 5,
      ),
      EffectModel(
        type: EffectType.credits,
        target: EffectTarget.self,
        value: 3,
      ),
    ];
  }

  /// Creates service mocks with default behavior
  static MockCardsSelectionManagerService createMockSelectionService() {
    return MockCardsSelectionManagerService();
  }

  static MockGamePhaseManager createMockGamePhaseManager() {
    return MockGamePhaseManager();
  }

  static MockActivePlayerManager createMockActivePlayerManager() {
    return MockActivePlayerManager();
  }

  static MockEffectProcessor createMockEffectProcessor() {
    return MockEffectProcessor();
  }

  /// Creates a mock PlayerCoordinator for testing
  static MockPlayerCoordinator createMockPlayerCoordinator({
    String name = 'Test Player',
    bool isActive = false,
  }) {
    final mockPlayerInfo = MockPlayerInfoCoordinator();
    when(() => mockPlayerInfo.name).thenReturn(name);
    when(() => mockPlayerInfo.isActive).thenReturn(isActive);
    
    final mockCoordinator = MockPlayerCoordinator();
    when(() => mockCoordinator.playerInfoCoordinator).thenReturn(mockPlayerInfo);
    
    return mockCoordinator;
  }

  /// Creates a mock PlayerInfoCoordinator for testing  
  static MockPlayerInfoCoordinator createMockPlayerInfoCoordinator({
    String name = 'Test Player',
    bool isActive = false,
  }) {
    final mock = MockPlayerInfoCoordinator();
    when(() => mock.name).thenReturn(name);
    when(() => mock.isActive).thenReturn(isActive);
    return mock;
  }
}