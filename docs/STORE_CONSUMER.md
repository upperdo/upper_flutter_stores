# StoreConsumer

The **StoreConsumer** widget is a utility for consuming and rebuilding UI based on changes to a specific store. It simplifies accessing a store from the widget tree and reacting to its state changes.

## Features

- Automatically rebuilds the widget when the store's state changes.
- Provides a clean and intuitive API for accessing stores within the widget tree.
- Avoids unnecessary boilerplate when interacting with stores.

---

## Usage

To use **StoreConsumer**, wrap it around your widget and provide a `builder` function. The `builder` function gives you access to the store and the `BuildContext`.

### Example

```dart
import 'package:flutter/material.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';
import 'todo_store.dart';

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
      ),
      body: StoreConsumer<TodoStore>(
        builder: (context, todoStore) {
          final tasks = todoStore.tasks;

          return tasks.isEmpty
              ? const Center(child: Text('No tasks available.'))
              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    final isDone = task['done'] == true;

                    return ListTile(
                      title: Text(
                        task['title'] ?? '',
                        style: TextStyle(
                          decoration: isDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      subtitle: Text(task['description'] ?? ''),
                      trailing: IconButton(
                        icon: Icon(
                          isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: isDone ? Colors.green : Colors.grey,
                        ),
                        onPressed: () => todoStore.completeTask(index),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
```

---

## Parameters

| Parameter | Type                                     | Description                                                      |
| --------- | ---------------------------------------- | ---------------------------------------------------------------- |
| `builder` | `Widget Function(BuildContext, T store)` | A function that builds the widget tree using the provided store. |

---

## Best Practices

1. **Minimize Rebuilds**: Ensure that only the necessary parts of the widget tree are rebuilt by scoping your **StoreConsumer** usage appropriately.

2. **Error Handling**: Include error and empty-state handling in your `builder` function to provide a smooth user experience.

3. **Readability**: Use meaningful variable names and structure the `builder` function to maintain code clarity.

---

## Conclusion

The **StoreConsumer** widget is a powerful tool for interacting with your stores in a clean, responsive manner. It eliminates boilerplate and ensures your UI reacts seamlessly to state changes. Integrate it into your workflow to simplify state-driven UI updates.

For more advanced usage and additional features, refer to the [documentation](https://github.com/upperdo/upper_flutter_stores).
