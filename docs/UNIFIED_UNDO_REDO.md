# Unified Undo/Redo Functionality

The **Undo/Redo Functionality** in the `upper_flutter_stores` package provides a seamless way to navigate through state changes. This feature is embedded in the **Unified Store**, making it easier to implement undoable state management with minimal effort.

---

## Enabling Undo/Redo

To enable the undo/redo functionality in a Unified Store, set the `enableUndoRedo` flag to `true` when initializing the store:

```dart
final store = StoreInterface(
  {
    'tasks': [],
  },
  enableUndoRedo: true,
);
```

---

## Key Methods

The following methods are available to manage the undo/redo functionality:

### `undo()`
Reverts the state to the last saved version.

```dart
store.undo();
```

### `redo()`
Restores the state to the version after the last undo operation.

```dart
store.redo();
```

### `canUndo`
Checks if there is a previous state available to revert to.

```dart
if (store.canUndo) {
  store.undo();
}
```

### `canRedo`
Checks if there is a forward state available to restore.

```dart
if (store.canRedo) {
  store.redo();
}
```

---

## Example Usage

Here is an example of using undo/redo functionality in a Flutter app:

```dart
class UndoRedoExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<TodoStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Undo/Redo Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: store.canUndo ? store.undo : null,
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: store.canRedo ? store.redo : null,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder(
              valueListenable: store,
              builder: (context, value, _) {
                final tasks = store.state['tasks'];
                return Text('Tasks: ${tasks.length}');
              },
            ),
            ElevatedButton(
              onPressed: () {
                store.set({
                  'tasks': [...store.state['tasks'], 'New Task'],
                });
              },
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Debugging Undo/Redo

If debugging is enabled, you can monitor undo/redo operations:

```dart
final store = StoreInterface(
  {
    'tasks': [],
  },
  enableUndoRedo: true,
  enableDebugging: true,
);
```

Debugging logs will show:
- State transitions during undo/redo operations.
- Current state after each action.

---

## Best Practices

- **Granular State Updates**: Ensure state changes are meaningful to take full advantage of undo/redo.
- **Avoid Redundant Updates**: Avoid unnecessary state updates as they might clutter the undo stack.
- **UI Feedback**: Use `canUndo` and `canRedo` to enable/disable UI controls based on availability.

---

## Conclusion
The **upper_flutter_stores** package is versatile and caters to various use cases across industries. Its modular design, robust features, and developer-friendly API make it a powerful tool for managing state in Flutter applications.
