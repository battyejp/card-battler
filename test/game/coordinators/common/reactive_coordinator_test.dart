import 'package:card_battler/game/coordinators/common/reactive_coordinator.dart';
import 'package:flutter_test/flutter_test.dart';

// Test class that uses the ReactiveCoordinator mixin
class TestReactiveModel with ReactiveCoordinator<TestReactiveModel> {
  TestReactiveModel(this.value);

  int value;

  void updateValue(int newValue) {
    value = newValue;
    notifyChange();
  }
}

// Another test class to verify generic type safety
class TestStringModel with ReactiveCoordinator<TestStringModel> {
  TestStringModel(this.data);

  String data;

  void updateData(String newData) {
    data = newData;
    notifyChange();
  }
}

void main() {
  group('ReactiveCoordinator', () {
    late TestReactiveModel testModel;

    setUp(() {
      testModel = TestReactiveModel(0);
    });

    tearDown(() {
      testModel.dispose();
    });

    group('Stream Management', () {
      test('creates broadcast stream on first access', () {
        final stream = testModel.changes;

        expect(stream, isNotNull);
        expect(stream.isBroadcast, isTrue);
      });
    });

    group('Change Notifications', () {
      test('notifyChange emits model instance to stream', () async {
        final changes = <TestReactiveModel>[];
        final subscription = testModel.changes.listen(changes.add);

        testModel.notifyChange();
        await Future.delayed(Duration.zero); // Allow stream to emit

        expect(changes, hasLength(1));
        expect(identical(changes.first, testModel), isTrue);

        await subscription.cancel();
      });

      test('notifyChange works with practical updates', () async {
        final changes = <TestReactiveModel>[];
        final subscription = testModel.changes.listen(changes.add);

        testModel.updateValue(42);
        await Future.delayed(Duration.zero);

        expect(changes, hasLength(1));
        expect(changes.first.value, equals(42));
        expect(identical(changes.first, testModel), isTrue);

        await subscription.cancel();
      });

      test('notifyChange does nothing when no listeners', () {
        // Should not throw or cause issues
        expect(() => testModel.notifyChange(), returnsNormally);
      });

      test('notifyChange after dispose does nothing', () {
        testModel.dispose();

        expect(() => testModel.notifyChange(), returnsNormally);
      });
    });

    group('Multiple Listeners', () {
      test('supports multiple simultaneous listeners', () async {
        final changes1 = <TestReactiveModel>[];
        final changes2 = <TestReactiveModel>[];

        final subscription1 = testModel.changes.listen(changes1.add);
        final subscription2 = testModel.changes.listen(changes2.add);

        testModel.notifyChange();
        await Future.delayed(Duration.zero);

        expect(changes1, hasLength(1));
        expect(changes2, hasLength(1));
        expect(identical(changes1.first, testModel), isTrue);
        expect(identical(changes2.first, testModel), isTrue);

        await subscription1.cancel();
        await subscription2.cancel();
      });
    });
  });
}
