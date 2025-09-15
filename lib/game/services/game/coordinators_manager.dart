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
import 'package:card_battler/game/coordinators/components/shop/shop_display_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_inventory_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/base_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/bases_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/players_info_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/team_coordinator.dart';
import 'package:card_battler/game/services/card/cards_selection_manager_service.dart';
import 'package:card_battler/game/services/card/effect_processor.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/game/game_state_facade.dart';

class CoordinatorsManager {
  late PlayerTurnSceneCoordinator _playerTurnSceneCoordinator;
  late EnemyTurnSceneCoordinator _enemyTurnSceneCoordinator;
  late PlayersInfoCoordinator _playersInfoCoordinator;
  late List<PlayerCoordinator> _playerCoordinators;

  PlayerTurnSceneCoordinator get playerTurnSceneCoordinator =>
      _playerTurnSceneCoordinator;
  EnemyTurnSceneCoordinator get enemyTurnSceneCoordinator =>
      _enemyTurnSceneCoordinator;
  PlayerCoordinator get activePlayerCoordinator =>
      _playerCoordinators.firstWhere((pc) => pc.playerInfoCoordinator.isActive);

  CoordinatorsManager() {
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
                          CardsSelectionManagerService.instance,
                      gamePhaseManager: GamePhaseManager.instance,
                    ),
                  )
                  .toList(),
            ),
            discardCardsCoordinator: CardListCoordinator<CardCoordinator>(
              cardCoordinators: [],
            ),
            playerInfoCoordinator: PlayerInfoCoordinator(model: player),
            gamePhaseManager: GamePhaseManager.instance,
          ),
        )
        .toList();

    _playersInfoCoordinator = PlayersInfoCoordinator(
      players: _playerCoordinators
          .map((pc) => pc.playerInfoCoordinator)
          .toList(),
    );

    var enemyCoordinators = GameStateFacade.instance.state!.enemiesModel.enemies
        .map((enemy) => EnemyCoordinator(model: enemy))
        .toList();

    var effectProcessor = EffectProcessor(
      _playersInfoCoordinator,
      enemyCoordinators,
    );

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
                cardsSelectionManagerService:
                    CardsSelectionManagerService.instance,
                gamePhaseManager: GamePhaseManager.instance,
              ),
            )
            .toList(),
      ),
      playersInfoCoordinator: _playersInfoCoordinator,
      effectProcessor: effectProcessor,
      gamePhaseManager: GamePhaseManager.instance,
    );

    _playerTurnSceneCoordinator = PlayerTurnSceneCoordinator(
      playerCoordinator: _playerCoordinators.firstWhere(
        (pc) => pc.playerInfoCoordinator.isActive,
      ),
      shopCoordinator: ShopCoordinator(
        displayCoordinator: ShopDisplayCoordinator(
          shopCardCoordinators: GameStateFacade
              .instance
              .state!
              .shop
              .inventoryCards
              .allCards
              .map(
                (card) => ShopCardCoordinator(
                  card,
                  CardsSelectionManagerService.instance,
                  GamePhaseManager.instance,
                ),
              )
              .toList(),
          itemsPerRow: 3,
          numberOfRows: 2,
        ),
        inventoryCoordinator: ShopInventoryCoordinator([]),
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
                  cardsSelectionManagerService:
                      CardsSelectionManagerService.instance,
                  gamePhaseManager: GamePhaseManager.instance,
                ),
              )
              .toList(),
        ),
        playedCardsCoordinator: CardListCoordinator<CardCoordinator>(
          cardCoordinators: [],
        ),
      ),
      gamePhaseManager: GamePhaseManager.instance,
      effectProcessor: effectProcessor,
    );
  }
}
