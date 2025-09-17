import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';
import 'package:card_battler/game/models/card/card_list_model.dart';
import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/shared/effect_model.dart';
import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:card_battler/game/services/card/cards_selection_manager_service.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'shared_mocks.mocks.dart';

// Generate mocks for these classes
@GenerateMocks([
  CardModel,
  CardsSelectionManagerService,
  GamePhaseManager,
  ActivePlayerManager,
  PlayerInfoCoordinator,
])
void main() {}

// Factory functions to create mock instances with default values
MockCardModel createMockCardModel({
  String name = 'Test Card',
  String type = 'action',
  bool isFaceUp = true,
  List<EffectModel> effects = const [],
}) {
  final mock = MockCardModel();
  when(mock.name).thenReturn(name);
  when(mock.type).thenReturn(type);
  when(mock.isFaceUp).thenReturn(isFaceUp);
  when(mock.effects).thenReturn(effects);
  return mock;
}

MockCardsSelectionManagerService createMockCardsSelectionManagerService() => MockCardsSelectionManagerService();

MockGamePhaseManager createMockGamePhaseManager() {
  final mock = MockGamePhaseManager();
  // Add any default behavior if needed
  return mock;
}

MockActivePlayerManager createMockActivePlayerManager([MockGamePhaseManager? gamePhaseManager]) {
  final mock = MockActivePlayerManager();
  // Add any default behavior if needed
  return mock;
}

MockPlayerInfoCoordinator createMockPlayerInfoCoordinator() {
  final mock = MockPlayerInfoCoordinator();
  // Add any default behavior if needed
  return mock;
}

// Helper function to create a mock player model for testing
PlayerModel createMockPlayerModel() => PlayerModel(
  name: 'Test Player',
  healthModel: HealthModel(100, 100),
  handCards: CardListModel<CardModel>(),
  deckCards: CardListModel<CardModel>(),
  discardCards: CardListModel<CardModel>(),
  isActive: true,
  credits: 10,
  attack: 5,
);

// Mock CardCoordinator for testing
class MockCardCoordinator extends CardCoordinator {
  MockCardCoordinator({String name = 'Test Card'})
    : super(
        cardModel: createMockCardModel(name: name),
        cardsSelectionManagerService: createMockCardsSelectionManagerService(),
        gamePhaseManager: createMockGamePhaseManager(),
        activePlayerManager: createMockActivePlayerManager(),
      );
}