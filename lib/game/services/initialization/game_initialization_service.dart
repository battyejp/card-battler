import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/services/card/card_loader_service.dart';
import 'package:card_battler/game/services/card/cards_selection_manager_service.dart';
import 'package:card_battler/game/services/game/coordinators_manager.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';
import 'package:card_battler/game/services/ui/dialog_service.dart';

class ServiceContainer {
  ServiceContainer({
    required this.dialogService,
    required this.cardsSelectionManagerService,
    required this.gamePhaseManager,
    required this.activePlayerManager,
    required this.coordinatorsManager,
  });

  final DialogService dialogService;
  final CardsSelectionManagerService cardsSelectionManagerService;
  final GamePhaseManager gamePhaseManager;
  final ActivePlayerManager activePlayerManager;
  final CoordinatorsManager coordinatorsManager;
}

class GameInitializationService {
  static Future<GameStateModel> initializeGameState() async {
    // print('Loading player deck cards...');
    final playerDeckCards =
        await CardLoaderService.loadCardsFromJson<CardModel>(
          'assets/data/hero_starting_cards.json',
          CardModel.fromJson,
        );
    // print('player deck cards loaded: ${playerDeckCards.length}');

    final enemyCards = await CardLoaderService.loadCardsFromJson<CardModel>(
      'assets/data/enemy_cards.json',
      CardModel.fromJson,
    );
    // print('enemy cards loaded: ${enemyCards.length}');

    final shopCards = await CardLoaderService.loadCardsFromJson<ShopCardModel>(
      'assets/data/shop_cards.json',
      ShopCardModel.fromJson,
    );
    // print('shop cards loaded: ${shopCards.length}');

    return GameStateModel.initialize(
      shopCards,
      playerDeckCards,
      enemyCards,
      [],
    );
  }

  static ServiceContainer createServices(GameStateModel state) {
    final dialogService = DialogService();
    final cardsSelectionManagerService = CardsSelectionManagerService();

    final gamePhaseManager = GamePhaseManager(
      numberOfPlayers: state.players.length,
    );

    final activePlayerManager = ActivePlayerManager(
      gamePhaseManager: gamePhaseManager,
    );

    final coordinatorsManager = CoordinatorsManager(
      gamePhaseManager,
      state,
      activePlayerManager,
      cardsSelectionManagerService,
      dialogService,
    );

    return ServiceContainer(
      dialogService: dialogService,
      cardsSelectionManagerService: cardsSelectionManagerService,
      gamePhaseManager: gamePhaseManager,
      activePlayerManager: activePlayerManager,
      coordinatorsManager: coordinatorsManager,
    );
  }
}
