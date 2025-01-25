import 'package:flutter_test/flutter_test.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Unified Store Tests', () {
    test('Basic State Management', () {
      final store = Store<int>(
        0,
        enableDebugging: true,
      );
      expect(store.state, 0);

      store.set(10);
      expect(store.state, 10);
    });

    test('Snapshot Functionality', () {
      final store = Store<int>(
        0,
        enableSnapshots: true,
        enableDebugging: true,
        debugContext: 'spanshotStore',
      );

      // Update state and take snapshots
      store.set(10);
      store.takeSnapshot();

      store.set(20);
      store.takeSnapshot();

      // Replay snapshots
      store.replaySnapshot(0);
      expect(store.state, 10);

      store.replaySnapshot(1);
      expect(store.state, 20);
    });

    //
    test('Async Functionality', () async {
      final store = Store<String>(
        '',
        enableAsync: true,
        enableDebugging: true,
        debugContext: 'asyncStore',
        asyncTask: () async {
          await Future.delayed(Duration(milliseconds: 100));
          return 'Loaded';
        },
      );

      await Future.delayed(Duration(milliseconds: 200));
      expect(store.asyncState?.data, 'Loaded');
      expect(store.state, 'Loaded');
    });

    //
    test('Computed Store Functionality', () {
      final baseStore = BaseStore<int>(2); // Base dependency store

      final store = Store<int>(
        0,
        enableComputed: true,
        compute: () => baseStore.state * 2, // Derived state logic
        computedDependencies: [baseStore],
        enableDebugging: true,
        debugContext: 'computedStore',
      );

      // Initial computed value
      expect(store.state, 4);

      // Update dependency and verify computed value
      baseStore.set(3);
      expect(store.state, 6);

      baseStore.set(5);
      expect(store.state, 10);
    });

    test('Undo/Redo Functionality', () {
      final store = Store<int>(0,
          enableUndoRedo: true,
          enableDebugging: true,
          debugContext: 'redoStore');

      // Verify initial state
      expect(store.state, 0);
      expect(store.canUndo, false);
      expect(store.canRedo, false);

      // Perform state updates
      store.set(1);
      expect(store.canUndo, true); // Undo should now be available

      store.set(2);

      // Undo last change
      store.undo();
      expect(store.state, 1);

      // Check redo availability
      expect(store.canRedo, true);

      // Redo last undone change
      store.redo();
      expect(store.state, 2);
    });

    test('Persistence Functionality', () async {
      // Set initial mock values for SharedPreferences
      SharedPreferences.setMockInitialValues({
        'test_store': '{"name":"Jane"}', // Pre-populate mock data
      });

      final store = Store<Map<String, String>>(
        {'name': 'John'},
        enablePersistence: true,
        persistKey: 'test_store',
        fromJson: (json) => Map<String, String>.from(json),
        toJson: (state) => state,
        enableDebugging: true,
        debugContext: 'setPersistentStore',
      );

      // Update state and persist it
      store.set({'name': 'Jane'});
      await store.persist();

      // Simulate app restart
      final restoredStore = Store<Map<String, String>>(
        {'name': 'Default'},
        enablePersistence: true,
        persistKey: 'test_store',
        fromJson: (json) => Map<String, String>.from(json),
        toJson: (state) => state,
        enableDebugging: true,
        debugContext: 'restoredPersistentStore',
      );

      // Wait for persistence initialization
      await restoredStore.initializePersistence();

      // Wait briefly to ensure state propagation
      await Future.delayed(Duration(milliseconds: 50));

      // Assert that the restored state matches the persisted state
      print('Test: Restored state: ${restoredStore.state}');
      expect(restoredStore.state, {'name': 'Jane'});
    });
  });
}
