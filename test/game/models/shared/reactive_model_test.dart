import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game_legacy/models/shared/reactive_model.dart';

// Test model class to test the ReactiveModel mixin
class TestReactiveModel with ReactiveModel<TestReactiveModel> {
  String _value;
  
  TestReactiveModel(this._value);
  
  String get value => _value;
  
  void setValue(String newValue) {
    _value = newValue;
    notifyChange();
  }
}

void main() {
  group('ReactiveModel', () {
    late TestReactiveModel model;

    setUp(() {
      model = TestReactiveModel('initial');
    });

    tearDown(() {
      model.dispose();
    });

    group('constructor and initialization', () {
      test('creates model with initial value', () {
        expect(model.value, equals('initial'));
      });

      test('changes stream is available', () {
        expect(model.changes, isA<Stream<TestReactiveModel>>());
      });
    });

    group('change notification', () {
      test('notifyChange emits current model instance', () async {
        final List<TestReactiveModel> changeEvents = [];
        
        // Listen to changes
        final subscription = model.changes.listen((model) {
          changeEvents.add(model);
        });

        // Trigger a change
        model.setValue('changed');

        // Wait for stream event
        await Future.delayed(const Duration(milliseconds: 1));

        expect(changeEvents.length, equals(1));
        expect(changeEvents.first, equals(model));
        expect(changeEvents.first.value, equals('changed'));

        subscription.cancel();
      });

      test('multiple changes emit multiple events', () async {
        final List<String> changeValues = [];
        
        final subscription = model.changes.listen((model) {
          changeValues.add(model.value);
        });

        // Trigger multiple changes with delays to ensure proper timing
        model.setValue('first');
        await Future.delayed(const Duration(milliseconds: 1));
        
        model.setValue('second');
        await Future.delayed(const Duration(milliseconds: 1));
        
        model.setValue('third');
        await Future.delayed(const Duration(milliseconds: 1));

        expect(changeValues.length, equals(3));
        expect(changeValues[0], equals('first'));
        expect(changeValues[1], equals('second'));
        expect(changeValues[2], equals('third'));

        subscription.cancel();
      });

      test('manual notifyChange works without setValue', () async {
        final List<TestReactiveModel> changeEvents = [];
        
        final subscription = model.changes.listen((model) {
          changeEvents.add(model);
        });

        // Manual notification
        model.notifyChange();

        // Wait for stream event
        await Future.delayed(const Duration(milliseconds: 1));

        expect(changeEvents.length, equals(1));
        expect(changeEvents.first, equals(model));

        subscription.cancel();
      });
    });

    group('stream behavior', () {
      test('changes stream is broadcast stream', () {
        final stream1 = model.changes;
        final stream2 = model.changes;
        
        expect(stream1, equals(stream2));
        expect(stream1.isBroadcast, isTrue);
      });

      test('multiple listeners can subscribe to changes', () async {
        final List<TestReactiveModel> listener1Events = [];
        final List<TestReactiveModel> listener2Events = [];
        
        final subscription1 = model.changes.listen((model) {
          listener1Events.add(model);
        });

        final subscription2 = model.changes.listen((model) {
          listener2Events.add(model);
        });

        // Trigger a change
        model.setValue('broadcast');

        // Wait for stream events
        await Future.delayed(const Duration(milliseconds: 1));

        expect(listener1Events.length, equals(1));
        expect(listener2Events.length, equals(1));
        expect(listener1Events.first.value, equals('broadcast'));
        expect(listener2Events.first.value, equals('broadcast'));

        subscription1.cancel();
        subscription2.cancel();
      });

      test('late listeners receive subsequent changes', () async {
        final List<TestReactiveModel> earlyEvents = [];
        final List<TestReactiveModel> lateEvents = [];
        
        // Early listener
        final earlySubscription = model.changes.listen((model) {
          earlyEvents.add(model);
        });

        // First change
        model.setValue('early');
        await Future.delayed(const Duration(milliseconds: 1));

        // Late listener
        final lateSubscription = model.changes.listen((model) {
          lateEvents.add(model);
        });

        // Second change
        model.setValue('late');
        await Future.delayed(const Duration(milliseconds: 1));

        expect(earlyEvents.length, equals(2)); // both changes
        expect(lateEvents.length, equals(1));  // only second change
        expect(lateEvents.first.value, equals('late'));

        earlySubscription.cancel();
        lateSubscription.cancel();
      });
    });

    group('disposal and cleanup', () {
      test('dispose closes stream controller', () async {
        final List<TestReactiveModel> changeEvents = [];
        bool streamClosed = false;
        
        final subscription = model.changes.listen(
          (model) => changeEvents.add(model),
          onDone: () => streamClosed = true,
        );

        // Trigger a change to ensure stream is working
        model.setValue('before_dispose');
        await Future.delayed(const Duration(milliseconds: 1));
        
        expect(changeEvents.length, equals(1));
        expect(streamClosed, isFalse);

        // Dispose the model
        model.dispose();
        await Future.delayed(const Duration(milliseconds: 1));

        expect(streamClosed, isTrue);
        subscription.cancel();
      });

      test('notifyChange after dispose does nothing', () async {
        model.dispose();
        
        // This should not throw
        expect(() => model.notifyChange(), returnsNormally);
      });

      test('accessing changes after dispose creates new controller', () async {
        model.dispose();
        
        // Accessing changes after dispose should work
        expect(model.changes, isA<Stream<TestReactiveModel>>());
        
        final List<TestReactiveModel> changeEvents = [];
        final subscription = model.changes.listen((model) {
          changeEvents.add(model);
        });

        model.setValue('after_dispose');
        await Future.delayed(const Duration(milliseconds: 1));

        expect(changeEvents.length, equals(1));
        expect(changeEvents.first.value, equals('after_dispose'));

        subscription.cancel();
      });
    });

    group('edge cases', () {
      test('handles rapid successive changes', () async {
        final List<TestReactiveModel> changeEvents = [];
        
        final subscription = model.changes.listen((model) {
          changeEvents.add(model);
        });

        // Rapid changes
        for (int i = 0; i < 10; i++) {
          model.setValue('rapid_$i');
        }

        // Wait for all stream events
        await Future.delayed(const Duration(milliseconds: 10));

        expect(changeEvents.length, equals(10));
        expect(changeEvents.last.value, equals('rapid_9'));

        subscription.cancel();
      });

      test('handles empty string values', () async {
        final List<TestReactiveModel> changeEvents = [];
        
        final subscription = model.changes.listen((model) {
          changeEvents.add(model);
        });

        model.setValue('');
        await Future.delayed(const Duration(milliseconds: 1));

        expect(changeEvents.length, equals(1));
        expect(changeEvents.first.value, equals(''));

        subscription.cancel();
      });
    });
  });
}