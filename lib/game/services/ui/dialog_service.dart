import 'dart:ui' show VoidCallback;

import 'package:card_battler/game/ui/components/common/confirm_dialog.dart';
import 'package:flame/game.dart';

/// Service responsible for managing dialog interactions and confirmations
/// This class handles all dialog-related operations, following the Single Responsibility Principle
class DialogService {
  static final DialogService _instance = DialogService._internal();
  factory DialogService() => _instance;
  DialogService._internal();

  RouterComponent? _router;

  void initialize({required RouterComponent router}) {
    _router = router;
  }

  /// Current dialog callbacks - used for custom dialogs
  VoidCallback? _currentOnConfirm;
  VoidCallback? _currentOnCancel;
  String _currentTitle = 'Confirm Action';
  String _currentMessage = 'Are you sure you want to continue?';

  /// Get confirmation dialog route for router setup
  Map<String, Route> getDialogRoutes() {
    return {
      'confirm': OverlayRoute((context, game) {
        return ConfirmDialog(
          title: _currentTitle,
          message: _currentMessage,
          onCancel: _handleConfirmCancel,
          onConfirm: _handleConfirmAccept,
        );
      }),
    };
  }

  /// Show custom confirmation dialog with specified callbacks and messages
  void showCustomConfirmation({
    required String title,
    required String message,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) {
    if (_router == null) {
      print(
        'Warning: DialogService router not initialized. Dialog cannot be shown.',
      );
      return;
    }

    _currentTitle = title;
    _currentMessage = message;
    _currentOnConfirm = onConfirm;
    _currentOnCancel = onCancel;

    try {
      _router!.pushNamed('confirm');
    } catch (e) {
      print('Error showing dialog: $e');
      // Fallback: execute confirm callback directly if dialog fails
      onConfirm();
    }
  }

  /// Handle confirmation dialog cancel
  void _handleConfirmCancel() {
    _router?.pop();
    _currentOnCancel?.call();
  }

  /// Handle confirmation dialog accept
  void _handleConfirmAccept() {
    _router?.pop();
    _currentOnConfirm?.call();
  }
}
