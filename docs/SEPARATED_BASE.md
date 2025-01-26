# Documentation: **upper_flutter_stores**

### BaseStore

The `BaseStore` is the core store implementation in the `upper_flutter_stores` package. It provides essential state management functionality and serves as the foundation for all other store types. It is lightweight, efficient, and designed to be extended or used directly in applications.

#### Key Features
- **State Management**: Manage state in a reactive manner with `set` and `state`.
- **Reactivity**: Automatically notify listeners when the state is updated.
- **Debugging**: Enable debugging to log state transitions and changes.

#### Usage

```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class CounterStore extends BaseStore<int> {
  CounterStore() : super(0); // Initial state is set to 0

  void increment() {
    set(state + 1); // Update state by incrementing the current value
  }

  void decrement() {
    set(state - 1); // Update state by decrementing the current value
  }
}
```

#### Example

```dart
import 'package:flutter/material.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class CounterScreen extends StatelessWidget {
  final CounterStore store = CounterStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Example'),
      ),
      body: Center(
        child: ValueListenableBuilder(
          valueListenable: store,
          builder: (context, value, _) {
            return Text(
              'Counter Value: $value',
              style: const TextStyle(fontSize: 24),
            );
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: store.increment,
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: store.decrement,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
```

#### Debugging
Enable debugging by passing `enableDebugging: true` to the constructor:

```dart
final store = BaseStore<int>(0, enableDebugging: true);
```
This will log state transitions in the console, aiding in tracing and debugging changes in the state.

---
