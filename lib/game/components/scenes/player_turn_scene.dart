import 'package:card_battler/game/components/enemy/enemies.dart';
import 'package:card_battler/game/components/player/player.dart';
import 'package:card_battler/game/components/shop/shop.dart';
import 'package:card_battler/game/components/team/team.dart';
import 'package:card_battler/game/components/shared/flat_button.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/services/turn/player_turn_coordinator.dart';
import 'package:card_battler/game/services/game_state/game_state_manager.dart';
import 'package:card_battler/game/services/game_state/game_state_service.dart';
import 'package:card_battler/game/services/card/card_interaction_service.dart';
import 'package:card_battler/game/services/card/card_selection_service.dart';
import 'package:card_battler/game/services/ui/scene_manager.dart';
import 'package:flame/components.dart';

class PlayerTurnScene extends Component {
  final PlayerTurnCoordinator _model;
  final Vector2 _size;
  final GameStateManager _gameStateManager = GameStateManager();
  final SceneManager _sceneManager = SceneManager();
  late final CardInteractionService _cardInteractionService;
  late final CardSelectionService _cardSelectionService;

  /// Expose CardSelectionService for external access (e.g., background deselection)
  CardSelectionService get cardSelectionService => _cardSelectionService;
  late final FlatButton turnButton;
  Player? _player;
  double _availableWidth = 0.0;
  double _bottomLayoutHeight = 0.0;

  PlayerTurnScene({required PlayerTurnCoordinator model, required Vector2 size})
      : _model = model,
        _size = size;

  static const double margin = 20.0;
  static const double topLayoutHeightFactor = 0.6;

  @override
  Future<void> onMount() async {
    super.onMount();
    
    _cardInteractionService = DefaultCardInteractionService(
      DefaultGameStateService(_gameStateManager)
    );
    _cardSelectionService = DefaultCardSelectionService();
    _loadGameComponents();
    _createTurnButton();
    _setupGameStateListener();
  }

  @override
  void onRemove() {
    _gameStateManager.removePhaseChangeListener(_onGamePhaseChanged);
    super.onRemove();
  }


  void _setupGameStateListener() {
    _gameStateManager.addPhaseChangeListener(_onGamePhaseChanged);
  }

  void _loadGameComponents() {
    final availableHeight = _size.y - (margin * 2);
    final topLayoutHeight = availableHeight * topLayoutHeightFactor;
    final topPositionY = -1 * (_size.y / 2) + margin;

    _availableWidth = _size.x - (margin * 2);
    _bottomLayoutHeight = availableHeight - topLayoutHeight;

    // Create player component with models from game state
    addPlayerComponent(_model.playerModel);

    // Create enemies component with model from game state
    final enemiesWidth = _availableWidth * 0.5;
    final enemies = Enemies(model: _model.enemiesModel)
      ..size = Vector2(enemiesWidth, topLayoutHeight)
      ..position = Vector2((0 - enemiesWidth / 2), topPositionY);

    add(enemies);

    // Create shop component with model from game state
    final shopWidth = _availableWidth * 0.5 / 2;
    final shop = Shop(
      _model.shopModel,
      cardInteractionService: _cardInteractionService,
      cardSelectionService: _cardSelectionService,
    )
      ..size = Vector2(shopWidth, topLayoutHeight)
      ..position = Vector2(enemies.position.x + enemiesWidth, topPositionY);

    add(shop);

    // Create team component with model from game state
    final team = Team(_model.teamModel)
      ..size = Vector2(shopWidth, topLayoutHeight)
      ..position = Vector2(0 - enemiesWidth / 2 - shopWidth, topPositionY);

    add(team);
  }

  void _onGamePhaseChanged(GamePhase previousPhase, GamePhase newPhase) {
    switch (newPhase) {
      case GamePhase.waitingToDrawCards:
        break;
      case GamePhase.cardsDrawnWaitingForEnemyTurn:
        turnButton.text = 'Take Enemy Turn';
        break;
      case GamePhase.enemyTurn:
        break;
      case GamePhase.playerTurn:
        turnButton.text = 'End Turn';
        break;
      case GamePhase.cardsDrawnWaitingForPlayerSwitch:
        turnButton.text = 'Switch Player';
        break;
    }

    turnButton.isVisible = newPhase != GamePhase.waitingToDrawCards && newPhase != GamePhase.enemyTurn;
  }

  void addPlayerComponent(PlayerModel playerModel) {
    _player?.removeFromParent();

    _player = Player(
      playerModel: playerModel,
      cardInteractionService: _cardInteractionService,
      cardSelectionService: _cardSelectionService,
    )
      ..size = Vector2(_availableWidth, _bottomLayoutHeight)
      ..position = Vector2(
        (0 - _size.x / 2) + margin,
        (_size.y / 2) - margin - _bottomLayoutHeight,
      );

    add(_player!);
  }

  void _createTurnButton() {
    turnButton = FlatButton(
      'Take Enemy Turn',
      size: Vector2(_size.x * 0.3, 0.1 * _size.y),
      position: Vector2(0, ((_size.y / 2) * -1) + (_size.y * 0.1)),
      onReleased: () {
        if (!turnButton.disabled && turnButton.isVisible) {
          _cardSelectionService.deselectCard();
          _sceneManager.handleTurnButtonPress();
        }
      }
    );

    turnButton.isVisible = false;
    add(turnButton);
  }
}