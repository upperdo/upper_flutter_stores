import 'package:upper_flutter_stores/upper_flutter_stores.dart';

abstract class StoreInterface<T> extends BaseStore<T> {
  final Store<T> store;
  bool isInitialized = false;

  StoreInterface(
    T initialState, {
    bool enableDebugging = false,
    String? debugContext,
    bool enableUndoRedo = false,
    bool enablePersistence = false,
    String? persistKey,
    T Function(Map<String, dynamic>)? fromJson,
    Map<String, dynamic> Function(T)? toJson,
    bool enableAsync = false,
    Future<T> Function()? asyncTask,
    bool enableComputed = false,
    T Function()? compute,
    List<BaseStore<dynamic>>? computedDependencies,
    bool enableSnapshots = false,
  })  : store = Store<T>(
          initialState,
          enableDebugging: enableDebugging,
          debugContext: debugContext,
          enableUndoRedo: enableUndoRedo,
          enablePersistence: enablePersistence,
          persistKey: persistKey,
          fromJson: fromJson,
          toJson: toJson,
          enableAsync: enableAsync,
          asyncTask: asyncTask,
          enableComputed: enableComputed,
          compute: compute,
          computedDependencies: computedDependencies,
          enableSnapshots: enableSnapshots,
        ),
        super(initialState, enableDebugging: enableDebugging);

  @override
  T get state => store.state;

  @override
  void set(T newState) {
    super.set(newState);
    store.set(newState);
    notifyListeners();

    if (store.enablePersistence) {
      store.persist();
    }

    if (enableDebugging) {
      print(
          '$runtimeType: State updated and persisted (if enabled): $newState');
    }
  }

  Future<void> initializePersistence() async {
    if (store.enablePersistence) {
      try {
        await store.initializePersistence();
        set(store.state);
        print('$runtimeType: Persistence initialized.');
      } catch (e) {
        print('$runtimeType: Persistence initialization failed - $e');
      }
    }
  }

  Future<void> persistState() async {
    if (store.enablePersistence) {
      try {
        await store.persist();
        print('$runtimeType: State persisted.');
      } catch (e) {
        print('$runtimeType: Failed to persist state - $e');
      }
    }
  }

  void setupMiddleware() {
    store.addMiddleware((oldState, newState) {
      print(
          '$runtimeType: Middleware: State changed from $oldState to $newState');
    });
  }

  void undo() {
    if (store.canUndo) {
      store.undo();
      set(store.state);
      print('$runtimeType: Undo performed. Current state: ${store.state}');
    } else {
      print('$runtimeType: Undo not available.');
    }
  }

  void redo() {
    if (store.canRedo) {
      store.redo();
      set(store.state);
      print('$runtimeType: Redo performed. Current state: ${store.state}');
    } else {
      print('$runtimeType: Redo not available.');
    }
  }

  void takeSnapshot() {
    if (store.enableSnapshots) {
      store.takeSnapshot();
      set(store.state);
      print('$runtimeType: Snapshot taken. Current state: ${store.state}');
    } else {
      print('$runtimeType: Snapshots are not enabled.');
    }
  }

  void replaySnapshot(int index) {
    if (store.enableSnapshots) {
      store.replaySnapshot(index);
      set(store.state);
      print(
          '$runtimeType: Snapshot at index $index replayed. Current state: ${store.state}');
    } else {
      print('$runtimeType: Snapshots are not enabled.');
    }
  }
}
