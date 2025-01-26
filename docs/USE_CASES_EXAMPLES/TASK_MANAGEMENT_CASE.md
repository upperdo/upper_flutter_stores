# Task Management Case Study

This document demonstrates how to create a task management application using the **upper_flutter_stores** package. The implementation prioritizes performance and simplicity, aligning with the philosophy of avoiding over-engineering while maintaining scalability and robustness.

---

## Features of the Task Management App

1. **Task Creation**: Add new tasks with a title, description, and category.
2. **Task Completion**: Mark tasks as completed or uncompleted.
3. **Task Deletion**: Remove tasks from the list.
4. **Persistence**: Ensure tasks remain available across app restarts.
5. **Undo/Redo**: Allow reverting accidental changes.
6. **MultiStore Management**: Separate concerns for tasks and categories.

---

## Architecture Overview

### Folder Structure

```plaintext
lib/
├── main.dart
├── screens/
│   ├── home_screen.dart
│   ├── add_task_screen.dart
│   ├── add_category_screen.dart
├── store/
│   ├── task_store.dart
│   ├── category_store.dart
└── widgets/
    ├── task_list.dart
    ├── category_list.dart
```

---

## Implementation

### 1. **Task Store**

```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class TaskStore extends StoreInterface<Map<String, dynamic>> {
  TaskStore()
      : super(
          {'tasks': []},
          enableDebugging: true,
          enableUndoRedo: true,
          enablePersistence: true,
          persistKey: 'task_store',
          fromJson: (json) => json,
          toJson: (state) => state,
        ){
    initializePersistence();
  }

  List<Map<String, dynamic>> get tasks =>
      List<Map<String, dynamic>>.from(state['tasks'] ?? []);

  void addTask(Map<String, dynamic> task) {
    set({'tasks': [...tasks, task]});
  }

  void toggleTaskCompletion(int index) {
    final updatedTasks = List<Map<String, dynamic>>.from(tasks);
    updatedTasks[index]['completed'] = !(updatedTasks[index]['completed'] ?? false);
    set({'tasks': updatedTasks});
  }

  void removeTask(int index) {
    final updatedTasks = List<Map<String, dynamic>>.from(tasks)..removeAt(index);
    set({'tasks': updatedTasks});
  }
}
```

### 2. **Category Store**

```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class CategoryStore extends StoreInterface<Map<String, dynamic>> {
  CategoryStore()
      : super(
          {'categories': []},
          enableDebugging: true,
          enablePersistence: true,
          persistKey: 'category_store',
          fromJson: (json) => json,
          toJson: (state) => state,
        ){
    initializePersistence();
  }

  List<String> get categories => List<String>.from(state['categories'] ?? []);

  void addCategory(String category) {
    set({'categories': [...categories, category]});
  }
}
```

---

### 3. **MultiStoreProvider Setup**

```dart
import 'package:flutter/material.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';
import 'screens/home_screen.dart';
import 'store/task_store.dart';
import 'store/category_store.dart';

void main() {
  runApp(const TaskManagementApp());
}

class TaskManagementApp extends StatelessWidget {
  const TaskManagementApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiStoreProvider(
      definitions: [
        StoreDefinition(TaskStore()),
        StoreDefinition(CategoryStore()),
      ],
      child: MaterialApp(
        title: 'Task Management',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeScreen(),
      ),
    );
  }
}
```

---

### 4. **Home Screen**

```dart
import 'package:flutter/material.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';
import '../store/task_store.dart';
import '../store/category_store.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Management')),
      body: Column(
        children: [
          Expanded(
            child: StoreConsumer<TaskStore>(
              builder: (context, taskStore) {
                final tasks = taskStore.tasks;
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return ListTile(
                      title: Text(task['title'] ?? ''),
                      subtitle: Text(task['description'] ?? ''),
                      trailing: IconButton(
                        icon: Icon(
                          task['completed'] == true
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: task['completed'] == true
                              ? Colors.green
                              : Colors.grey,
                        ),
                        onPressed: () => taskStore.toggleTaskCompletion(index),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/add_task'),
            child: const Text('Add Task'),
          ),
        ],
      ),
    );
  }
}
```

---

### 5. **Performance Tips**

- **Use `StoreConsumer`**: Only rebuild the widgets that depend on store updates.
- **Keep Stores Lightweight**: Avoid placing unnecessary logic in stores; delegate it to services if needed.
- **Leverage MultiStoreProvider**: Group stores logically to improve maintainability.

---

This example showcases how to use `upper_flutter_stores` to build a performant, scalable, and developer-friendly task management application.
