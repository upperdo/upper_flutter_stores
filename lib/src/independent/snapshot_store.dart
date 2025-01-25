import 'base_store.dart';

class SnapshotStore<T> extends BaseStore<T> {
  final List<T> _snapshots = [];
  final String? debugContext;

  SnapshotStore(
    T initialState, {
    this.debugContext,
    bool enableDebugging = false,
  }) : super(initialState, enableDebugging: enableDebugging) {
    if (enableDebugging) {
      print(
          'SnapshotStore [$debugContext]: Initialized with state: $initialState');
    }
  }

  void takeSnapshot() {
    _snapshots.add(state);
    if (enableDebugging) {
      print('SnapshotStore [$debugContext]: Snapshot taken: $state');
    }
  }

  void replay(int index) {
    if (index >= 0 && index < _snapshots.length) {
      if (enableDebugging) {
        print(
            'SnapshotStore [$debugContext]: Replaying snapshot at $index: ${_snapshots[index]}');
      }
      set(_snapshots[index]);
    } else {
      if (enableDebugging) {
        print(
            'SnapshotStore [$debugContext]: Invalid index for replay: $index');
      }
    }
  }

  void clearSnapshots() {
    _snapshots.clear();
    if (enableDebugging) {
      print('SnapshotStore [$debugContext]: All snapshots cleared.');
    }
  }

  List<T> get snapshots {
    if (enableDebugging) {
      print(
          'SnapshotStore [$debugContext]: Returning snapshot list: $_snapshots');
    }
    return List.unmodifiable(_snapshots);
  }
}
