import 'base_store.dart';

class ComputedStore<T> extends BaseStore<T> {
  final T Function() _compute;
  final List<BaseStore<dynamic>> _dependencies;
  final String? debugContext;

  ComputedStore(
    T initialState,
    this._compute,
    this._dependencies, {
    bool enableDebugging = false,
    this.debugContext,
  }) : super(initialState, enableDebugging: enableDebugging) {
    if (enableDebugging) {
      print(
          'ComputedStore [$debugContext]: Initializing with dependencies: $_dependencies');
    }

    // Set the initial computed value
    _updateState();

    // Subscribe to all dependencies and update state on change
    for (var dependency in _dependencies) {
      dependency.subscribe((_) {
        if (enableDebugging) {
          print(
              'ComputedStore [$debugContext]: Dependency changed: $dependency');
        }
        _updateState();
      });
    }
  }

  void _updateState() {
    try {
      final newValue = _compute();
      if (enableDebugging) {
        print('ComputedStore [$debugContext]: Computed new value: $newValue');
      }
      super.set(newValue);
    } catch (e, stack) {
      if (enableDebugging) {
        print('ComputedStore [$debugContext]: Error while computing value: $e');
        print('ComputedStore [$debugContext]: Stack trace: $stack');
      }
      rethrow;
    }
  }

  @override
  void set(T newState) {
    throw UnsupportedError(
      'ComputedStore [$debugContext]: Cannot directly set a value for ComputedStore. The value is derived from dependencies.',
    );
  }
}
