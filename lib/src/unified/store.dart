import '../independent/base_store.dart';
import '../independent/async_store.dart';
import '../independent/undoable_store.dart';
import '../independent/computed_store.dart';
import '../independent/persistent_store.dart';
import '../independent/snapshot_store.dart';
import '../middleware//middleware_store.dart';

class Store<T> extends BaseStore<T> {
  final UndoableStore<T>? _undoableFeature;
  final PersistentStore<T>? _persistentFeature;
  final AsyncStore<T>? _asyncFeature;
  final ComputedStore<T>? _computedFeature;
  final SnapshotStore<T>? _snapshotFeature;
  final List<Middleware<T>> _middlewares = [];

  Store(
    T initialState, {
    bool enableDebugging = false,
    String? debugContext, // Pass debugging context
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
  })  : _undoableFeature = enableUndoRedo
            ? _initializeUndoableFeature(
                initialState,
                enableDebugging: enableDebugging,
                debugContext: debugContext,
              )
            : null,
        _persistentFeature = enablePersistence
            ? _initializePersistentFeature(
                initialState,
                persistKey,
                fromJson,
                toJson,
                enableDebugging,
                debugContext,
              )
            : null,
        _asyncFeature = enableAsync
            ? AsyncStore<T>(
                enableDebugging: enableDebugging,
                debugContext: debugContext,
              )
            : null,
        _computedFeature = enableComputed
            ? _initializeComputedFeature(
                initialState,
                compute,
                computedDependencies,
                enableDebugging,
                debugContext,
              )
            : null,
        _snapshotFeature = enableSnapshots
            ? _initializeSnapshotFeature(
                initialState,
                enableDebugging: enableDebugging,
                debugContext: debugContext,
              )
            : null,
        super(initialState, enableDebugging: enableDebugging) {
    if (enableDebugging) {
      print('Store initialized with context: $debugContext');
    }

    if (_asyncFeature != null && asyncTask != null) {
      _asyncFeature!.run(asyncTask).then((_) {
        if (_asyncFeature!.state.data != null) {
          set(_asyncFeature!.state.data as T);
        }
      });
    }

    if (_computedFeature != null) {
      _computedFeature!.subscribe((computedState) {
        if (enableDebugging) {
          print('Store: Computed state updated: $computedState');
        }
        super.set(computedState);
      });
    }
  }

  void addMiddleware(Middleware<T> middleware) {
    _middlewares.add(middleware);
    if (enableDebugging) {
      print('Middleware added.');
    }
  }

  void removeMiddleware(Middleware<T> middleware) {
    _middlewares.remove(middleware);
    if (enableDebugging) {
      print('Middleware removed.');
    }
  }

  static UndoableStore<T> _initializeUndoableFeature<T>(
    T initialState, {
    required bool enableDebugging,
    String? debugContext,
  }) {
    return UndoableStore<T>(
      initialState,
      enableDebugging: enableDebugging,
      debugContext: debugContext != null
          ? '$debugContext -> UndoableStore'
          : 'UndoableStore',
    );
  }

  static PersistentStore<T>? _initializePersistentFeature<T>(
    T initialState,
    String? persistKey,
    T Function(Map<String, dynamic>)? fromJson,
    Map<String, dynamic> Function(T)? toJson,
    bool enableDebugging,
    String? debugContext,
  ) {
    if (persistKey == null || fromJson == null || toJson == null) {
      throw ArgumentError(
          'Persistence requires a persistKey, fromJson, and toJson.');
    }
    return PersistentStore<T>(
      initialState,
      persistKey: persistKey,
      fromJson: fromJson,
      toJson: toJson,
    )
      ..enableDebugging = enableDebugging
      ..debugContext = debugContext != null
          ? '$debugContext -> PersistentStore'
          : 'PersistentStore';
  }

  static ComputedStore<T>? _initializeComputedFeature<T>(
    T initialState,
    T Function()? compute,
    List<BaseStore<dynamic>>? dependencies,
    bool enableDebugging,
    String? debugContext,
  ) {
    if (compute == null || dependencies == null) {
      throw ArgumentError(
          'Computed store requires a compute function and dependencies.');
    }
    return ComputedStore<T>(
      initialState,
      compute,
      dependencies,
      enableDebugging: enableDebugging,
      debugContext: debugContext != null
          ? '$debugContext -> ComputedStore'
          : 'ComputedStore',
    );
  }

  static SnapshotStore<T>? _initializeSnapshotFeature<T>(
    T initialState, {
    required bool enableDebugging,
    String? debugContext,
  }) {
    return SnapshotStore<T>(
      initialState,
      enableDebugging: enableDebugging,
      debugContext: debugContext != null
          ? '$debugContext -> SnapshotStore'
          : 'SnapshotStore',
    );
  }

  @override
  void set(T newState) {
    for (var middleware in _middlewares) {
      middleware(state, newState);
    }

    if (enableDebugging) {
      print('Store: State updated from $state to $newState');
    }

    if (_undoableFeature != null) {
      _undoableFeature!.set(newState);
      super.set(_undoableFeature!.state);
    } else {
      super.set(newState);
    }

    if (_persistentFeature != null) {
      _persistentFeature!.set(state);
    }
  }

  Future<void> initializePersistence() async {
    if (_persistentFeature != null) {
      await _persistentFeature!.initialize();
      super.set(_persistentFeature!.state);
    } else {
      throw UnsupportedError('Persistence is not enabled for this Store.');
    }
  }

  bool get canUndo => _undoableFeature?.canUndo ?? false;

  void undo() {
    if (_undoableFeature != null && _undoableFeature!.canUndo) {
      _undoableFeature!.undo();
      super.set(_undoableFeature!.state);
    } else {
      throw UnsupportedError(
          'Undo/Redo is not enabled or no undo is available.');
    }
  }

  bool get canRedo => _undoableFeature?.canRedo ?? false;

  void redo() {
    if (_undoableFeature != null && _undoableFeature!.canRedo) {
      _undoableFeature!.redo();
      super.set(_undoableFeature!.state);
    } else {
      throw UnsupportedError(
          'Undo/Redo is not enabled or no redo is available.');
    }
  }

  Future<void> persist() async {
    if (_persistentFeature != null) {
      await _persistentFeature!.persist();
    } else {
      throw UnsupportedError('Persistence is not enabled for this Store.');
    }
  }

  void takeSnapshot() {
    if (_snapshotFeature != null) {
      _snapshotFeature!.set(state);
      _snapshotFeature!.takeSnapshot();
    } else {
      throw UnsupportedError('Snapshots are not enabled for this Store.');
    }
  }

  void replaySnapshot(int index) {
    if (_snapshotFeature != null) {
      _snapshotFeature!.replay(index);
      super.set(_snapshotFeature!.state);
    } else {
      throw UnsupportedError('Snapshots are not enabled for this Store.');
    }
  }

  Future<void> runAsync(Future<T> Function() task) async {
    if (_asyncFeature != null) {
      await _asyncFeature!.run(task);
      if (_asyncFeature!.state.data != null) {
        set(_asyncFeature!.state.data as T);
      }
    } else {
      throw UnsupportedError(
          'Async functionality is not enabled for this Store.');
    }
  }

  AsyncState<T>? get asyncState => _asyncFeature?.state;
}
