# Unified Store Implementation

The **Unified Store** allows you to combine various store functionalities (e.g., undoable, persistent, async) into a single, cohesive store.

### Creating a Unified Store

Define your store by extending `StoreInterface` and initializing the desired features:

```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class TodoStore extends StoreInterface<Map<String, dynamic>> {
  TodoStore()
      : super(
          {
            'tasks': <Map<String, dynamic>>[],
            'categories': <String>['General'],
          },
          enableDebugging: true,
          enableUndoRedo: true,
          enablePersistence: true,
          persistKey: 'todo_store',
          fromJson: (json) => Map<String, dynamic>.from(json),
          toJson: (state) => state,
        ) {
    initializePersistence();
  }

  List<Map<String, dynamic>> get tasks => state['tasks'] ?? [];

  void addTask(Map<String, dynamic> task) {
    set({
      ...state,
      'tasks': [...tasks, task],
    });
  }

  void removeTask(int index) {
    final updatedTasks = [...tasks]..removeAt(index);
    set({
      ...state,
      'tasks': updatedTasks,
    });
  }
}
```

### Key Parameters for StoreInterface

| Parameter           | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| `initialState`      | The initial state of the store.                                             |
| `enableDebugging`   | Enables debug logs for state changes.                                       |
| `enableUndoRedo`    | Enables undo/redo functionality.                                            |
| `enablePersistence` | Persists the state to storage. Requires `persistKey`, `fromJson`, `toJson`. |
| `persistKey`        | A unique key to identify the store in storage.                              |
| `fromJson`          | A function to deserialize the state from JSON.                              |
| `toJson`            | A function to serialize the state to JSON.                                  |

### Usage Example

```dart
final todoStore = TodoStore();

todoStore.addTask({'title': 'Buy groceries', 'done': false});
todoStore.removeTask(0);
todoStore.undo(); // Reverts the last state change.
todoStore.redo(); // Redoes the reverted change.
```
