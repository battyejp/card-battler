import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/services/card/card_ui_service.dart';

void main() {
  group('DefaultCardUIService', () {
    group('isButtonEnabled', () {
      test('returns true when no business logic check provided', () {
        final service = DefaultCardUIService();
        expect(service.canPlayCard(), isTrue);
      });

      test('returns true when business logic check returns true', () {
        final service = DefaultCardUIService(
          businessLogicCheck: () => true,
        );
        expect(service.canPlayCard(), isTrue);
      });

      test('returns false when business logic check returns false', () {
        final service = DefaultCardUIService(
          businessLogicCheck: () => false,
        );
        expect(service.canPlayCard(), isFalse);
      });

      test('calls business logic check function', () {
        bool checkWasCalled = false;
        final service = DefaultCardUIService(
          businessLogicCheck: () {
            checkWasCalled = true;
            return true;
          },
        );

        service.canPlayCard();
        expect(checkWasCalled, isTrue);
      });

      test('handles multiple calls correctly', () {
        int callCount = 0;
        final service = DefaultCardUIService(
          businessLogicCheck: () {
            callCount++;
            return callCount % 2 == 1; // Alternates true/false
          },
        );

        expect(service.canPlayCard(), isTrue);  // First call
        expect(service.canPlayCard(), isFalse); // Second call
        expect(service.canPlayCard(), isTrue);  // Third call
        expect(callCount, equals(3));
      });
    });

    group('constructor behavior', () {
      test('accepts null business logic check', () {
        expect(() => DefaultCardUIService(businessLogicCheck: null), returnsNormally);
        
        final service = DefaultCardUIService(businessLogicCheck: null);
        expect(service.canPlayCard(), isTrue);
      });

      test('accepts business logic check function', () {
        bool check() => true;
        expect(() => DefaultCardUIService(businessLogicCheck: check), returnsNormally);
      });

      test('accepts default constructor', () {
        expect(() => DefaultCardUIService(), returnsNormally);
      });
    });

    group('edge cases', () {
      test('handles business logic check that throws exception', () {
        final service = DefaultCardUIService(
          businessLogicCheck: () => throw Exception('Test error'),
        );

        // The exception should propagate since there's no error handling
        expect(() => service.canPlayCard(), throwsException);
      });

      test('business logic check can access external state', () {
        bool externalFlag = false;
        final service = DefaultCardUIService(
          businessLogicCheck: () => externalFlag,
        );

        expect(service.canPlayCard(), isFalse);
        
        externalFlag = true;
        expect(service.canPlayCard(), isTrue);
      });
    });

    group('interface compliance', () {
      test('implements CardUIService interface', () {
        final service = DefaultCardUIService();
        expect(service, isA<CardUIService>());
      });

      test('provides all required interface methods', () {
        final service = DefaultCardUIService();
        
        // Should not throw - methods exist and are callable
        expect(() => service.canPlayCard(), returnsNormally);
      });
    });

    group('business logic integration', () {
      test('business logic check can be complex function', () {
        int counter = 0;
        final service = DefaultCardUIService(
          businessLogicCheck: () {
            counter++;
            return counter > 2 && counter % 2 == 0;
          },
        );

        expect(service.canPlayCard(), isFalse); // counter = 1
        expect(service.canPlayCard(), isFalse); // counter = 2
        expect(service.canPlayCard(), isFalse); // counter = 3
        expect(service.canPlayCard(), isTrue);  // counter = 4
        expect(service.canPlayCard(), isFalse); // counter = 5
        expect(service.canPlayCard(), isTrue);  // counter = 6
      });

      test('business logic independence from interaction allowance', () {
        final service = DefaultCardUIService(
          businessLogicCheck: () => false,
        );

        // Button is disabled by business logic
        expect(service.canPlayCard(), isFalse);
      });
    });
  });
}