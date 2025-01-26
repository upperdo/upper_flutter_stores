# Documentation: **upper_flutter_stores**

## Undo/Redo Functionality

The **undo/redo** functionality in `upper_flutter_stores` allows you to manage state changes in a reversible manner. This feature is particularly useful for applications that require the ability to revert or redo changes, such as text editors, form inputs, or task managers.

### Enabling Undo/Redo
Undo/Redo is supported by the unified `Store` and can be enabled when initializing a `StoreInterface`. To enable this feature, set the `enableUndoRedo` parameter to `true` when creating your store.

```dart
class TodoStore extends StoreInterface<Map<String, dynamic>> {
  TodoStore()
      : super(
          {
            'tasks': <Map<String, dynamic>>[],
            'categories': <String>['General'],
          },
          enableDebugging: true,
          enableUndoRedo: true,
        );
}
```

### Using Undo/Redo

#### Undo
To revert to the previous state, call the `undo` method on your store. Ensure that the `undo` method is only called when `canUndo` is `true`.

```dart
void undoAction(TodoStore store) {
  if (store.canUndo) {
    store.undo();
    print('Undo performed. Current state: ${store.state}');
  } else {
    print('No undo available.');
  }
}
```

#### Redo
To reapply a reverted state, call the `redo` method. Ensure that the `redo` method is only called when `canRedo` is `true`.

```dart
void redoAction(TodoStore store) {
  if (store.canRedo) {
    store.redo();
    print('Redo performed. Current state: ${store.state}');
  } else {
    print('No redo available.');
  }
}
```

### Example
Here is an example of how undo/redo functionality can be used in a Flutter application:

```dart
import 'package:flutter/material.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';
import 'todo_store.dart';

class UndoRedoExample extends StatelessWidget {
  const UndoRedoExample({Key? key}) : super(key: key);

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
      body: ValueListenableBuilder(
        valueListenable: store,
        builder: (context, value, _) {
          final tasks = store.tasks;
          return tasks.isEmpty
              ? const Center(child: Text('No tasks available.'))
              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return ListTile(
                      title: Text(task['title'] ?? ''),
                      subtitle: Text(task['description'] ?? ''),
                    );
                  },
                );
        },
      ),
    );
  }
}
```
