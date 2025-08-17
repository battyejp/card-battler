import 'package:card_battler/game/components/reactive_position_component.dart';
import 'package:card_battler/game/models/shared/reactive_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flame_test/flame_test.dart';

// Test model implementing ReactiveModel
class TestModel with ReactiveModel<TestModel> {
  int _value = 0;
  
  int get value => _value;
  
  void setValue(int newValue) {
    _value = newValue;
    notifyChange();
  }
}

// Test component extending ReactivePositionComponent
class TestComponent extends ReactivePositionComponent<TestModel> {
  int updateDisplayCallCount = 0;
  
  TestComponent(super.model);
  
  @override
  void onLoad() {
    updateDisplay();
  }
  
  @override
  void updateDisplay() {
    updateDisplayCallCount++;
  }
}

void main() {
  group('ReactivePositionComponent', () {
    testWithFlameGame('calls updateDisplay on model changes', (game) async {
      final model = TestModel();
      final component = TestComponent(model);
      
      await game.ensureAdd(component);
      
      // Initial call from onLoad
      expect(component.updateDisplayCallCount, equals(1));
      
      // Change model - should trigger updateDisplay
      model.setValue(5);
      await game.ready();
      
      expect(component.updateDisplayCallCount, equals(2));
      
      // Another change
      model.setValue(10);
      await game.ready();
      
      expect(component.updateDisplayCallCount, equals(3));
    });
    
    testWithFlameGame('cleans up stream subscription on removal', (game) async {
      final model = TestModel();
      final component = TestComponent(model);
      
      await game.ensureAdd(component);
      
      expect(component.updateDisplayCallCount, equals(1));
      
      // Remove component
      game.remove(component);
      await game.ready();
      
      // Model changes should not trigger updateDisplay after removal
      model.setValue(5);
      await game.ready();
      
      expect(component.updateDisplayCallCount, equals(1)); // Still 1, not 2
    });
    
    testWithFlameGame('handles multiple components with same model', (game) async {
      final model = TestModel();
      final component1 = TestComponent(model);
      final component2 = TestComponent(model);
      
      await game.ensureAdd(component1);
      await game.ensureAdd(component2);
      
      // Both should be called initially
      expect(component1.updateDisplayCallCount, equals(1));
      expect(component2.updateDisplayCallCount, equals(1));
      
      // Model change should trigger both
      model.setValue(5);
      await game.ready();
      
      expect(component1.updateDisplayCallCount, equals(2));
      expect(component2.updateDisplayCallCount, equals(2));
    });
  });
}