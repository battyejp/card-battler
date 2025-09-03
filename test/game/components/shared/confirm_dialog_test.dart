import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/shared/confirm_dialog.dart';

void main() {
  group('ConfirmDialog', () {
    group('constructor and initialization', () {
      testWidgets('creates with required parameters', (tester) async {
        bool confirmCalled = false;
        bool cancelCalled = false;

        final dialog = ConfirmDialog(
          onConfirm: () => confirmCalled = true,
          onCancel: () => cancelCalled = true,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: dialog),
          ),
        );

        expect(find.text('Confirm Action'), findsOneWidget);
        expect(find.text('Are you sure you want to continue?'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('Confirm'), findsOneWidget);
      });

      testWidgets('creates with custom title and message', (tester) async {
        bool confirmCalled = false;
        bool cancelCalled = false;

        final dialog = ConfirmDialog(
          onConfirm: () => confirmCalled = true,
          onCancel: () => cancelCalled = true,
          title: 'Delete Item',
          message: 'This action cannot be undone.',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: dialog),
          ),
        );

        expect(find.text('Delete Item'), findsOneWidget);
        expect(find.text('This action cannot be undone.'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('Confirm'), findsOneWidget);
      });
    });

    group('button functionality', () {
      testWidgets('confirm button triggers onConfirm callback', (tester) async {
        bool confirmCalled = false;
        bool cancelCalled = false;

        final dialog = ConfirmDialog(
          onConfirm: () => confirmCalled = true,
          onCancel: () => cancelCalled = true,
          title: 'Test Dialog',
          message: 'Test message',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: dialog),
          ),
        );

        // Find and tap the confirm button
        await tester.tap(find.text('Confirm'));
        await tester.pump();

        expect(confirmCalled, isTrue);
        expect(cancelCalled, isFalse);
      });

      testWidgets('cancel button triggers onCancel callback', (tester) async {
        bool confirmCalled = false;
        bool cancelCalled = false;

        final dialog = ConfirmDialog(
          onConfirm: () => confirmCalled = true,
          onCancel: () => cancelCalled = true,
          title: 'Test Dialog',
          message: 'Test message',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: dialog),
          ),
        );

        // Find and tap the cancel button
        await tester.tap(find.text('Cancel'));
        await tester.pump();

        expect(confirmCalled, isFalse);
        expect(cancelCalled, isTrue);
      });

      testWidgets('both callbacks can be called independently', (tester) async {
        int confirmCount = 0;
        int cancelCount = 0;

        final dialog = ConfirmDialog(
          onConfirm: () => confirmCount++,
          onCancel: () => cancelCount++,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: dialog),
          ),
        );

        // Tap cancel multiple times
        await tester.tap(find.text('Cancel'));
        await tester.pump();
        await tester.tap(find.text('Cancel'));
        await tester.pump();

        // Tap confirm multiple times  
        await tester.tap(find.text('Confirm'));
        await tester.pump();
        await tester.tap(find.text('Confirm'));
        await tester.pump();
        await tester.tap(find.text('Confirm'));
        await tester.pump();

        expect(cancelCount, equals(2));
        expect(confirmCount, equals(3));
      });
    });

    group('visual appearance and styling', () {
      testWidgets('has correct visual structure', (tester) async {
        final dialog = ConfirmDialog(
          onConfirm: () {},
          onCancel: () {},
          title: 'Visual Test',
          message: 'Testing visual elements',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: dialog),
          ),
        );

        // Check for container with proper styling
        expect(find.byType(Container), findsWidgets);
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(Row), findsOneWidget);
        expect(find.byType(ElevatedButton), findsNWidgets(2));
        expect(find.byType(SizedBox), findsWidgets);
      });

      testWidgets('title has bold font weight', (tester) async {
        final dialog = ConfirmDialog(
          onConfirm: () {},
          onCancel: () {},
          title: 'Bold Title',
          message: 'Regular message',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: dialog),
          ),
        );

        // Find the title text widget
        final titleText = tester.widget<Text>(find.text('Bold Title'));
        expect(titleText.style?.fontWeight, equals(FontWeight.bold));
        expect(titleText.style?.fontSize, equals(18));
        expect(titleText.style?.color, equals(Colors.black));
      });

      testWidgets('message has center alignment', (tester) async {
        final dialog = ConfirmDialog(
          onConfirm: () {},
          onCancel: () {},
          message: 'Centered message text',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: dialog),
          ),
        );

        // Find the message text widget
        final messageText = tester.widget<Text>(find.text('Centered message text'));
        expect(messageText.textAlign, equals(TextAlign.center));
        expect(messageText.style?.color, equals(Colors.black));
      });

      testWidgets('cancel button has grey background', (tester) async {
        final dialog = ConfirmDialog(
          onConfirm: () {},
          onCancel: () {},
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: dialog),
          ),
        );

        // Find the cancel button
        final cancelButtons = find.widgetWithText(ElevatedButton, 'Cancel');
        expect(cancelButtons, findsOneWidget);

        final cancelButton = tester.widget<ElevatedButton>(cancelButtons);
        final buttonStyle = cancelButton.style as ButtonStyle?;
        final backgroundColor = buttonStyle?.backgroundColor?.resolve({});
        expect(backgroundColor, equals(Colors.grey));
      });

      testWidgets('confirm button has blue background', (tester) async {
        final dialog = ConfirmDialog(
          onConfirm: () {},
          onCancel: () {},
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: dialog),
          ),
        );

        // Find the confirm button
        final confirmButtons = find.widgetWithText(ElevatedButton, 'Confirm');
        expect(confirmButtons, findsOneWidget);

        final confirmButton = tester.widget<ElevatedButton>(confirmButtons);
        final buttonStyle = confirmButton.style as ButtonStyle?;
        final backgroundColor = buttonStyle?.backgroundColor?.resolve({});
        expect(backgroundColor, equals(Colors.blue));
      });
    });

    group('edge cases and special scenarios', () {
      testWidgets('handles empty title and message', (tester) async {
        final dialog = ConfirmDialog(
          onConfirm: () {},
          onCancel: () {},
          title: '',
          message: '',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: dialog),
          ),
        );

        expect(find.text(''), findsNWidgets(2)); // Empty title and message
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('Confirm'), findsOneWidget);
      });

      testWidgets('handles very long title and message', (tester) async {
        const longText = 'This is a very long text that might cause layout issues if not handled properly. It contains many words and should test text wrapping behavior.';
        
        final dialog = ConfirmDialog(
          onConfirm: () {},
          onCancel: () {},
          title: longText,
          message: longText,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: dialog),
          ),
        );

        expect(find.text(longText), findsNWidgets(2)); // Title and message
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('Confirm'), findsOneWidget);
      });

      testWidgets('dialog maintains structure with different screen sizes', (tester) async {
        final dialog = ConfirmDialog(
          onConfirm: () {},
          onCancel: () {},
          title: 'Responsive Test',
          message: 'Testing responsiveness',
        );

        // Test with different screen sizes
        await tester.binding.setSurfaceSize(const Size(800, 600));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: dialog),
          ),
        );

        expect(find.text('Responsive Test'), findsOneWidget);
        expect(find.text('Testing responsiveness'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsNWidgets(2));

        // Test with smaller screen
        await tester.binding.setSurfaceSize(const Size(400, 300));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: dialog),
          ),
        );

        expect(find.text('Responsive Test'), findsOneWidget);
        expect(find.text('Testing responsiveness'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsNWidgets(2));

        // Reset to default size
        await tester.binding.setSurfaceSize(null);
      });
    });

    group('integration and usability', () {
      testWidgets('works properly in overlay or dialog context', (tester) async {
        bool confirmed = false;
        bool cancelled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => Center(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          child: ConfirmDialog(
                            onConfirm: () {
                              confirmed = true;
                              Navigator.of(context).pop();
                            },
                            onCancel: () {
                              cancelled = true;
                              Navigator.of(context).pop();
                            },
                            title: 'Dialog Test',
                            message: 'Testing in dialog context',
                          ),
                        ),
                      );
                    },
                    child: const Text('Show Dialog'),
                  ),
                ),
              ),
            ),
          ),
        );

        // Tap to show dialog
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Verify dialog is shown
        expect(find.text('Dialog Test'), findsOneWidget);
        expect(find.text('Testing in dialog context'), findsOneWidget);

        // Tap confirm
        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();

        expect(confirmed, isTrue);
        expect(cancelled, isFalse);
      });
    });
  });
}