# MultiStoreProvider

The **MultiStoreProvider** widget allows developers to efficiently manage multiple state stores in a Flutter application by wrapping them in a single widget. This approach simplifies dependency injection and state management when multiple stores are required in the widget tree.

---

## Key Features

- Simplifies managing multiple stores by combining them into a single widget.
- Reduces boilerplate for injecting multiple providers.
- Compatible with the **StoreProvider** for individual store injection.
- Supports strong typing for stores, ensuring type safety and flexibility.

---

## Usage

### Import the Package

Before using the **MultiStoreProvider**, import the package:

```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';
```

### Example Implementation

Below is a comprehensive example demonstrating how to use **MultiStoreProvider** to inject multiple stores into your Flutter application.

```dart
import 'package:flutter/material.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class TodoStore extends StoreInterface<Map<String, dynamic>> {
  TodoStore()
      : super(
          {'tasks': [], 'categories': []},
          enableDebugging: true,
        );
}

class SampleStore extends StoreInterface<Map<String, dynamic>> {
  SampleStore()
      : super(
          {'sampleData': 'Hello MultiStore!'},
          enableDebugging: true,
        );
}

class MultiStoreExampleScreen extends StatelessWidget {
  const MultiStoreExampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiStoreProvider(
      definitions: [
        StoreDefinition<TodoStore>(TodoStore()),
        StoreDefinition<SampleStore>(SampleStore()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('MultiStoreProvider Example'),
        ),
        body: Column(
          children: [
            Expanded(
              child: StoreConsumer<TodoStore>(
                builder: (context, todoStore) {
                  final tasks = todoStore.state['tasks'] ?? [];
                  return tasks.isEmpty
                      ? const Center(child: Text('No tasks available'))
                      : ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) => ListTile(
                            title: Text('Task ${index + 1}'),
                          ),
                        );
                },
              ),
            ),
            Expanded(
              child: StoreConsumer<SampleStore>(
                builder: (context, sampleStore) {
                  final sampleData = sampleStore.state['sampleData'];
                  return Center(
                    child: Text('Sample Data: $sampleData'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Implementation Details

### MultiStoreProvider Constructor

```dart
MultiStoreProvider({
  required List<BaseStoreDefinition> definitions,
  required Widget child,
})
```

- **`definitions`**: A list of `StoreDefinition` objects, each specifying a store type and its instance.
- **`child`**: The widget tree that the providers will wrap.

### StoreDefinition

A helper class used to pair a store with its corresponding **StoreProvider**.

```dart
StoreDefinition<TodoStore>(TodoStore()),
StoreDefinition<SampleStore>(SampleStore()),
```

---

## When to Use

Use the **MultiStoreProvider** when your application requires multiple stores for managing state. This widget reduces complexity by combining providers into a single, manageable structure.

---

For further information, visit the full [documentation repository](https://github.com/upperdo/upper_flutter_stores).
