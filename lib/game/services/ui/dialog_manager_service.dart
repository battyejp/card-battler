import 'package:card_battler/game/components/shared/confirm_dialog.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/services/game_state/game_state_manager.dart';
import 'package:flame/game.dart';

/// Service responsible for managing dialog interactions and confirmations
/// This class handles all dialog-related operations, following the Single Responsibility Principle
class DialogManagerService {
  static final DialogManagerService _instance = DialogManagerService._internal();
  factory DialogManagerService() => _instance;
  DialogManagerService._internal();

  RouterComponent? _router;
  final GameStateManager _gameStateManager = GameStateManager();

  /// Initialize the dialog manager with required router component
  void initialize({required RouterComponent router}) {
    _router = router;
    _setupConfirmationListener();
  }

  /// Get confirmation dialog route for router setup
  Map<String, Route> getDialogRoutes() {
    return {
      'confirm': OverlayRoute((context, game) {
        return ConfirmDialog(
          title: 'You still have cards in your hand!',
          onCancel: _handleConfirmCancel,
          onConfirm: _handleConfirmAccept,
        );
      }),
    };
  }

  /// Show confirmation dialog for ending turn with cards
  void showEndTurnConfirmation() {
    _router?.pushNamed('confirm');
  }

  /// Handle confirmation dialog cancel
  void _handleConfirmCancel() {
    _router?.pop();
  }

  /// Handle confirmation dialog accept
  void _handleConfirmAccept() {
    _router?.pop();
    _endPlayerTurn();
  }

  /// End player turn properly through the model
  void _endPlayerTurn() {
    GameStateModel.instance.playerTurn.endTurn();
  }

  /// Set up confirmation request listener
  void _setupConfirmationListener() {
    _gameStateManager.addConfirmationRequestListener(() {
      showEndTurnConfirmation();
    });
  }

  /// Get debug information about current dialog state
  String get debugInfo => 'DialogManagerService: initialized';
}