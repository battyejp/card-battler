import 'dart:ui' show VoidCallback;

class DialogState {
  DialogState({
    this.title = 'Confirm Action',
    this.message = 'Are you sure you want to continue?',
    this.onConfirm,
    this.onCancel,
  });

  final String title;
  final String message;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
}
