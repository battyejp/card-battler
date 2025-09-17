import 'dart:ui' show VoidCallback;
import 'package:card_battler/game/ui/components/common/confirm_dialog.dart';
import 'package:flame/game.dart';

class DialogService {
  RouterComponent? _router;

  void initialize({required RouterComponent router}) {
    _router = router;
  }

  VoidCallback? _currentOnConfirm;
  VoidCallback? _currentOnCancel;
  String _currentTitle = 'Confirm Action';
  String _currentMessage = 'Are you sure you want to continue?';

  /// Get confirmation dialog route for router setup
  Map<String, Route> getDialogRoutes() => {
      'confirm': OverlayRoute((context, game) => ConfirmDialog(
          title: _currentTitle,
          message: _currentMessage,
          onCancel: _handleConfirmCancel,
          onConfirm: _handleConfirmAccept,
        )),
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

    _currentTitle = title;
    _currentMessage = message;
    _currentOnConfirm = onConfirm;
    _currentOnCancel = onCancel;

    try {
      _router!.pushNamed('confirm');
    } catch (e) {
      onConfirm();
    }
  }

  void _handleConfirmCancel() {
    _router?.pop();
    _currentOnCancel?.call();
  }

  void _handleConfirmAccept() {
    _router?.pop();
    _currentOnConfirm?.call();
  }
}
