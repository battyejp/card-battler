import 'dart:async';
import 'package:card_battler/game/coordinators/common/reactive_coordinator.dart';
import 'package:flame/components.dart';

/// Base class for position components that react to model changes
///
/// This class handles the stream subscription lifecycle and provides
/// an abstract updateDisplay method that subclasses must implement
abstract class ReactivePositionComponent<T extends ReactiveCoordinator<T>>
    extends PositionComponent {
  ReactivePositionComponent(this.coordinator);

  final T coordinator;
  late StreamSubscription<T> _modelSubscription;

  /// Base implementation that clears all child components
  /// Subclasses should call super.updateDisplay() first, then add their components
  void updateDisplay() {
    removeWhere((component) => true);
  }

  @override
  void onMount() {
    super.onMount();
    // Listen to model changes and update display automatically
    _modelSubscription = coordinator.changes.listen((_) => updateDisplay());
  }

  @override
  void onRemove() {
    _modelSubscription.cancel();
    super.onRemove();
  }

  @override
  void onLoad() {
    super.onLoad();
    updateDisplay(); //TODO Should this be in onMount?
  }
}
