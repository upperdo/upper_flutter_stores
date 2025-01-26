# SnapshotStore

The `SnapshotStore` is a powerful extension of `BaseStore` that allows you to take snapshots of the store's state at any point in time and replay those snapshots when needed. This feature is useful for implementing time-travel debugging, undo/redo functionality, or for maintaining different application states during development or testing.

#### Features
- Take snapshots of the current state.
- Replay snapshots by index.
- Maintain a history of snapshots for debugging and state tracking.

#### Constructor
```dart
SnapshotStore<T>(
  T initialState, {
  bool enableDebugging = false,
  String? debugContext,
})
```

##### Parameters
- `initialState`: The initial state of the store.
- `enableDebugging`: If `true`, enables debug logs for snapshot operations.
- `debugContext`: A string used to identify the store in debug logs.

#### Methods

##### `takeSnapshot`
Takes a snapshot of the current state and adds it to the history.

```dart
void takeSnapshot()
```

##### `replay`
Replays a snapshot from the history by its index.

```dart
void replay(int index)
```

##### `snapshotHistory`
Returns the list of all snapshots stored in the `SnapshotStore`.

```dart
List<T> get snapshotHistory
```

#### Example Usage

```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class CounterStore extends SnapshotStore<int> {
  CounterStore() : super(0, enableDebugging: true, debugContext: 'CounterStore');

  void increment() {
    set(state + 1);
    takeSnapshot();
  }

  void decrement() {
    set(state - 1);
    takeSnapshot();
  }

  void resetToSnapshot(int index) {
    replay(index);
  }
}

void main() {
  final store = CounterStore();

  store.increment(); // State: 1, Snapshot taken
  store.increment(); // State: 2, Snapshot taken
  store.decrement(); // State: 1, Snapshot taken

  print(store.snapshotHistory); // [0, 1, 2, 1]

  store.resetToSnapshot(1); // State reset to 1 (second snapshot)
}
```

#### Best Practices
- Use snapshots for debugging purposes and to keep track of state changes over time.
- Avoid storing excessive numbers of snapshots if memory usage is a concern. Consider limiting the size of the snapshot history.
