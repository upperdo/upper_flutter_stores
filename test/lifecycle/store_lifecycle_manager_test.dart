import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upper_flutter_stores/src/lifecycle/store_lifecycle_manager.dart';

void main() {
  group('StoreLifecycleManager', () {
    testWidgets('Executes dispose callbacks when disposed', (tester) async {
      bool wasDisposed = false;

      // A test widget wrapped with StoreLifecycleManager
      await tester.pumpWidget(
        StoreLifecycleManager(
          debuggable: true,
          child: Builder(
            builder: (context) {
              StoreLifecycleManager.register(context, () {
                wasDisposed = true;
              });
              return const Placeholder();
            },
          ),
        ),
      );

      // Verify the widget is present
      expect(find.byType(Placeholder), findsOneWidget);

      // Replace the widget with a different one, triggering disposal
      await tester.pumpWidget(const Placeholder());

      // Verify the dispose callback was executed
      expect(wasDisposed, true);
    });

    testWidgets('Throws an error when register is called outside of context',
        (tester) async {
      await tester.pumpWidget(const Placeholder());

      expect(
        () => StoreLifecycleManager.register(
          tester.element(find.byType(Placeholder)),
          () {},
        ),
        throwsA(isA<FlutterError>()),
      );
    });
  });
}
