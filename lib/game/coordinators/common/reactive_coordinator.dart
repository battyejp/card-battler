import 'dart:async';

/// Mixin that provides reactive capabilities to models
/// Models that use this mixin can notify listeners when their state changes
mixin ReactiveCoordinator<T> {
  StreamController<T>? _changeController;

  /// Stream that emits when the model changes
  Stream<T> get changes {
    _changeController ??= StreamController<T>.broadcast();
    return _changeController!.stream;
  }

  /// Notifies listeners that the model has changed
  void notifyChange() {
    _changeController?.add(this as T);
  }

  /// Disposes of the stream controller
  void dispose() {
    _changeController?.close();
    _changeController = null;
  }
}
