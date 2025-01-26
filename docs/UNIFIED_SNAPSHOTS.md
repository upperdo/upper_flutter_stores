# Snapshots and Replay

The `upper_flutter_stores` package provides a **snapshot** and **replay** mechanism, which allows you to take snapshots of your store's state and replay them later. This feature is particularly useful for debugging and state management in complex applications.

### Enabling Snapshots

Snapshots are an optional feature that must be explicitly enabled when initializing the store. To enable snapshots, set `enableSnapshots: true` when creating the store.

```dart
final todoStore = TodoStore(
  enableSnapshots: true,
);
```

### Taking Snapshots

To capture the current state of a store, call the `takeSnapshot` method:

```dart
store.takeSnapshot();
```

This method saves the current state of the store to the snapshot stack. Snapshots are stored in memory and can be replayed later to inspect previous states.

### Replaying Snapshots

You can replay a snapshot by its index using the `replaySnapshot` method:

```dart
store.replaySnapshot(snapshotIndex);
```

Replaying a snapshot restores the state of the store to the captured snapshot at the specified index.

### Example Usage

Here is an example of taking snapshots and replaying them:

```dart
// Take a snapshot of the current state
store.takeSnapshot();

// Modify the state
store.addTask({'title': 'Snapshot Example', 'done': false});

// Replay the first snapshot
store.replaySnapshot(0);
```

In this example:
- A snapshot is taken before modifying the store's state.
- The state is modified by adding a task.
- The store's state is restored to the snapshot taken earlier.

### Snapshot Metadata

Snapshots do not automatically include metadata such as timestamps. If you require metadata, you can implement it by adding custom logic in your application, for example:

```dart
final snapshotWithMetadata = {
  'timestamp': DateTime.now(),
  'state': store.state,
};
```

### Integration with the `StoreInterface`

When using the `StoreInterface`, snapshots are seamlessly integrated:

```dart
class TodoStore extends StoreInterface<Map<String, dynamic>> {
  TodoStore()
      : super(
          {
            'tasks': <Map<String, dynamic>>[],
          },
          enableSnapshots: true,
        );

  void takeTodoSnapshot() {
    takeSnapshot();
  }

  void replayTodoSnapshot(int index) {
    replaySnapshot(index);
  }
}
```

This example demonstrates how to use the snapshot and replay functionality within a store class.

### Notes

- **Performance:** Snapshots are stored in memory, so consider memory usage when working with a large number of snapshots.
- **Replay Limitations:** Replaying snapshots resets the state of the store to the captured state but does not undo side effects such as API calls or UI changes.

Snapshots and replay provide a powerful toolset for debugging and managing state in your application.

---

## Conclusion
The **upper_flutter_stores** package is versatile and caters to various use cases across industries. Its modular design, robust features, and developer-friendly API make it a powerful tool for managing state in Flutter applications.
