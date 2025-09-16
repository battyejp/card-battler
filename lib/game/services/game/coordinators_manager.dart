import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/enemy/enemies_coordinator.dart';
import 'package:card_battler/game/coordinators/components/enemy/enemy_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/enemy_turn_scene_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/player_turn_scene_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/base_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/bases_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/players_info_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/team_coordinator.dart';
import 'package:card_battler/game/services/card/cards_selection_manager_service.dart';
import 'package:card_battler/game/services/card/effect_processor.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/game/game_state_facade.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';

class CoordinatorsManager {
  late PlayerTurnSceneCoordinator _playerTurnSceneCoordinator;
  late EnemyTurnSceneCoordinator _enemyTurnSceneCoordinator;
  late PlayersInfoCoordinator _playersInfoCoordinator;
  late List<PlayerCoordinator> _playerCoordinators;

  PlayerTurnSceneCoordinator get playerTurnSceneCoordinator =>
      _playerTurnSceneCoordinator;
  EnemyTurnSceneCoordinator get enemyTurnSceneCoordinator =>
      _enemyTurnSceneCoordinator;

  CoordinatorsManager(GamePhaseManager gamePhaseManager) {
    var effectProcessor = EffectProcessor();
    var cardsSelectionManagerService = CardsSelectionManagerService();
    var activePlayerManager = ActivePlayerManager(
      gamePhaseManager: gamePhaseManager,
    );

    _playerCoordinators = GameStateFacade.instance.state!.players
        .map(
          (player) => PlayerCoordinator(
            handCardsCoordinator: CardListCoordinator<CardCoordinator>(
              cardCoordinators: [],
            ),
            deckCardsCoordinator: CardListCoordinator<CardCoordinator>(
              cardCoordinators: player.deckCards.allCards
                  .map(
                    (card) => CardCoordinator(
                      cardModel: card.copy(),
                      cardsSelectionManagerService:
                          cardsSelectionManagerService,
                      gamePhaseManager: gamePhaseManager,
                      activePlayerManager: activePlayerManager,
                    ),
                  )
                  .toList(),
            ),
            discardCardsCoordinator: CardListCoordinator<CardCoordinator>(
              cardCoordinators: [],
            ),
            playerInfoCoordinator: PlayerInfoCoordinator(model: player),
            gamePhaseManager: gamePhaseManager,
            effectProcessor: effectProcessor,
          ),
        )
        .toList();

    _playersInfoCoordinator = PlayersInfoCoordinator(
      players: _playerCoordinators
          .map((pc) => pc.playerInfoCoordinator)
          .toList(),
    );

    effectProcessor.playersInfoCoordinator = _playersInfoCoordinator;
    activePlayerManager.players = _playerCoordinators;
    activePlayerManager.setNextPlayerToActive();

    var enemyCoordinators = GameStateFacade.instance.state!.enemiesModel.enemies
        .map((enemy) => EnemyCoordinator(model: enemy))
        .toList();

    _enemyTurnSceneCoordinator = EnemyTurnSceneCoordinator(
      playedCardsCoordinator: CardListCoordinator<CardCoordinator>(
        cardCoordinators: [],
      ),
      deckCardsCoordinator: CardListCoordinator<CardCoordinator>(
        cardCoordinators: GameStateFacade
            .instance
            .state!
            .enemiesModel
            .deckCards
            .allCards
            .map(
              (card) => CardCoordinator(
                cardModel: card.copy(),
                cardsSelectionManagerService: cardsSelectionManagerService,
                gamePhaseManager: gamePhaseManager,
                activePlayerManager: activePlayerManager,
              ),
            )
            .toList(),
      ),
      playersInfoCoordinator: _playersInfoCoordinator,
      effectProcessor: effectProcessor,
      gamePhaseManager: gamePhaseManager,
      numberOfCardsToDrawPerEnemyTurn: 1,
    );

    _playerTurnSceneCoordinator = PlayerTurnSceneCoordinator(
      playerCoordinator: _playerCoordinators.firstWhere(
        (pc) => pc.playerInfoCoordinator.isActive,
      ),
      shopCoordinator: ShopCoordinator(
        displayCoordinators: CardListCoordinator<ShopCardCoordinator>(
          cardCoordinators: [],
        ),
        inventoryCoordinators: CardListCoordinator<ShopCardCoordinator>(
          cardCoordinators: GameStateFacade
              .instance
              .state!
              .shop
              .inventoryCards
              .allCards
              .map(
                (card) => ShopCardCoordinator(
                  card,
                  cardsSelectionManagerService,
                  gamePhaseManager,
                  activePlayerManager,
                ),
              )
              .toList(),
        ),
      ),
      teamCoordinator: TeamCoordinator(
        playersInfoCoordinator: _playersInfoCoordinator,
        basesCoordinator: BasesCoordinator(
          baseCoordinators: GameStateFacade.instance.state!.bases
              .map((base) => BaseCoordinator(model: base))
              .toList(),
        ),
      ),
      enemiesCoordinator: EnemiesCoordinator(
        enemyCoordinators: enemyCoordinators,
        deckCardsCoordinator: CardListCoordinator<CardCoordinator>(
          cardCoordinators: GameStateFacade
              .instance
              .state!
              .enemiesModel
              .deckCards
              .allCards
              .map(
                (card) => CardCoordinator(
                  cardModel: card.copy(),
                  cardsSelectionManagerService: cardsSelectionManagerService,
                  gamePhaseManager: gamePhaseManager,
                  activePlayerManager: activePlayerManager,
                ),
              )
              .toList(),
        ),
        playedCardsCoordinator: CardListCoordinator<CardCoordinator>(
          cardCoordinators: [],
        ),
      ),
      gamePhaseManager: gamePhaseManager,
      effectProcessor: effectProcessor,
      activePlayerManager: activePlayerManager,
    );
  }
}
