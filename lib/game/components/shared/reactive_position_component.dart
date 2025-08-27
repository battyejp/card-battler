import 'dart:async';
import 'package:flame/components.dart';
import 'package:card_battler/game/models/shared/reactive_model.dart';

/// Base class for position components that react to model changes
/// 
/// This class handles the stream subscription lifecycle and provides
/// an abstract updateDisplay method that subclasses must implement
abstract class ReactivePositionComponent<T extends ReactiveModel<T>> extends PositionComponent {
  final T model;
  late StreamSubscription<T> _modelSubscription;

  ReactivePositionComponent(this.model);

  /// Base implementation that clears all child components
  /// Subclasses should call super.updateDisplay() first, then add their components
  void updateDisplay() {
    removeWhere((component) => true);
  }

  @override
  void onMount() {
    super.onMount();
    // Listen to model changes and update display automatically
    _modelSubscription = model.changes.listen((_) => updateDisplay());
  }

  @override
  void onRemove() {
    _modelSubscription.cancel();
    super.onRemove();
  }

  @override
  onLoad() {
    super.onLoad();
    updateDisplay();
  }

}