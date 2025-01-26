# Persistence

The **`upper_flutter_stores`** package allows you to persist state effortlessly using the built-in **PersistentStore** feature. This functionality enables applications to maintain state across app restarts or page reloads.

#### Enabling Persistence
To enable persistence for a store, configure the `StoreInterface` with:
- **`enablePersistence`** set to `true`.
- A unique **`persistKey`** to identify the store in persistent storage.
- `fromJson` and `toJson` methods to handle serialization and deserialization.

#### Example: Enabling Persistence for a Store
Here is an example of a store with persistence enabled:

```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class TodoStore extends StoreInterface<Map<String, dynamic>> {
  TodoStore()
      : super(
          {
            'tasks': <Map<String, dynamic>>[],
            'categories': <String>['General'],
          },
          enablePersistence: true, // Enable persistence
          persistKey: 'todo_store', // Unique key
          fromJson: (json) {
            final tasks = (json['tasks'] as List<dynamic>?)
                    ?.map((e) => Map<String, dynamic>.from(e as Map))
                    .toList() ??
                [];
            final categories = (json['categories'] as List<dynamic>?)
                    ?.map((e) => e as String)
                    .toList() ??
                [];
            return {
              'tasks': tasks,
              'categories': categories,
            };
          },
          toJson: (state) => state,
        ) {
    initializePersistence();
  }

  /// Add a task
  void addTask(Map<String, dynamic> task) {
    final updatedTasks = [...state['tasks'], task];
    set({
      ...state,
      'tasks': updatedTasks,
    });
  }
}
```

In this example:
- **`enablePersistence: true`** activates persistence.
- **`persistKey: 'todo_store'`** ensures this store’s data is uniquely identified.
- **`fromJson`** and **`toJson`** handle the conversion between JSON and the internal state representation.

#### Persistence Methods
- **`initializePersistence()`**: Loads the previously saved state, if available.
- **`persistState()`**: Explicitly saves the current state to persistent storage.

#### Behavior
- When a store is initialized, it attempts to load the state from persistent storage automatically.
- State changes are automatically persisted when using the **`set`** method.

#### Accessing Persistent Data
The persistent data is retrieved seamlessly as part of the store's state, so no additional code is required to handle it in your widgets.

#### Example: Using a Persistent Store
```dart
final todoStore = TodoStore();

todoStore.addTask({'title': 'Task 1', 'done': false});

// State will persist across app restarts.
```
