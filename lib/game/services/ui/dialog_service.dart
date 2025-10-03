import 'dart:ui' show VoidCallback;
import 'package:card_battler/game/ui/components/common/confirm_dialog.dart';
import 'package:flame/game.dart';
import 'dialog_state.dart';

class DialogService {
  RouterComponent? _router;
  DialogState _currentState = DialogState();

  void initialize({required RouterComponent router}) {
    _router = router;
  }

  /// Get confirmation dialog route for router setup
  Map<String, Route> getDialogRoutes() => {
    'confirm': OverlayRoute(
      (context, game) => ConfirmDialog(
        title: _currentState.title,
        message: _currentState.message,
        onCancel: _handleConfirmCancel,
        onConfirm: _handleConfirmAccept,
      ),
    ),
  };

  /// Show custom confirmation dialog with specified callbacks and messages
  void showCustomConfirmation({
    required String title,
    required String message,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) {
    if (_router == null) {
      return;
    }

    _currentState = DialogState(
      title: title,
      message: message,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );

    try {
      _router!.pushNamed('confirm');
    } catch (e) {
      onConfirm();
    }
  }

  void _handleConfirmCancel() {
    _router?.pop();
    _currentState.onCancel?.call();
  }

  void _handleConfirmAccept() {
    _router?.pop();
    _currentState.onConfirm?.call();
  }
}
