import 'dart:async';
import 'package:flame/components.dart';
import 'package:card_battler/game/models/reactive_model.dart';

/// Base class for position components that react to model changes
/// 
/// This class handles the stream subscription lifecycle and provides
/// an abstract updateDisplay method that subclasses must implement
abstract class ReactivePositionComponent<T extends ReactiveModel<T>> extends PositionComponent {
  final T model;
  late StreamSubscription<T> _modelSubscription;

  ReactivePositionComponent(this.model);

  /// Abstract method that subclasses must implement to update their display
  /// This method is called automatically when the model changes
  void updateDisplay();

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