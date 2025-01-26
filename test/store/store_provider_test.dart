import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upper_flutter_stores/src/independent/base_store.dart';
import 'package:upper_flutter_stores/src/store/store_provider.dart';

void main() {
  group('StoreProvider', () {
    testWidgets(
      'provides the store to child widgets',
      (WidgetTester tester) async {
        final store = BaseStore<int>(0, enableDebugging: true);

        await tester.pumpWidget(
          MaterialApp(
            home: StoreProvider<BaseStore<int>>(
              store: store,
              child: Builder(
                builder: (context) {
                  final providedStore =
                      StoreProvider.of<BaseStore<int>>(context);
                  return Text(
                    'Store Value: ${providedStore.state}',
                    textDirection: TextDirection.ltr,
                  );
                },
              ),
            ),
          ),
        );

        expect(find.text('Store Value: 0'), findsOneWidget);
      },
    );

    testWidgets(
      'updates child widgets when store state changes',
      (WidgetTester tester) async {
        final store = BaseStore<int>(0, enableDebugging: true);

        // Wrap the StoreProvider with a MaterialApp for context and use Builder to access the provider.
        await tester.pumpWidget(
          MaterialApp(
            home: StoreProvider<BaseStore<int>>(
              store: store,
              child: Builder(
                builder: (context) {
                  final providedStore =
                      StoreProvider.of<BaseStore<int>>(context);
                  return AnimatedBuilder(
                    animation: providedStore,
                    builder: (context, _) {
                      return Text(
                        'Store Value: ${providedStore.state}',
                        textDirection: TextDirection.ltr,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );

        // Initial value check
        expect(find.text('Store Value: 0'), findsOneWidget);

        // Update the store value
        store.set(42);
        await tester.pumpAndSettle(); // Ensure rebuilds are complete

        // Updated value check
        expect(find.text('Store Value: 42'), findsOneWidget);
      },
    );

    testWidgets(
      'throws an assertion error if StoreProvider is not found',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(
                  () => StoreProvider.of<BaseStore<int>>(context),
                  throwsAssertionError,
                );
                return const SizedBox();
              },
            ),
          ),
        );
      },
    );
  });
}
