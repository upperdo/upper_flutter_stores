# Documentation: **upper_flutter_stores**

## UndoableStore

The `UndoableStore` is a specialized store designed to handle undo and redo functionality. It allows you to revert to a previous state or reapply a reverted change. This is particularly useful in applications where users may need to undo actions or retry actions they've undone.

### Features
- **Undo and Redo:** Easily traverse state changes with undo and redo functionality.
- **Undo/Redo Stack Management:** Keeps track of state history to enable smooth transitions between states.
- **Debugging Support:** Logs state changes when debugging is enabled.

### Usage
To use the `UndoableStore`, simply wrap it around your initial state and define how it should handle undo/redo operations.

### Constructor
```dart
UndoableStore<T>(
  T initialState, {
  bool enableDebugging = false,
  String? debugContext,
})
```

### Example
Here’s how to integrate the `UndoableStore` into your application:

#### 1. Define an Undoable Store
```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class CounterUndoableStore extends UndoableStore<int> {
  CounterUndoableStore()
      : super(0, enableDebugging: true, debugContext: "CounterUndoableStore");

  void increment() {
    set(state + 1);
  }

  void decrement() {
    set(state - 1);
  }
}
```

#### 2. Use the Undoable Store in a Widget
```dart
import 'package:flutter/material.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class UndoableCounterScreen extends StatelessWidget {
  const UndoableCounterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counterStore = CounterUndoableStore();

    return StoreProvider<CounterUndoableStore>(
      store: counterStore,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Undoable Counter Example'),
        ),
        body: Center(
          child: ValueListenableBuilder<int>(
            valueListenable: counterStore,
            builder: (context, value, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Counter Value: $value', style: const TextStyle(fontSize: 24)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: counterStore.increment,
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: counterStore.decrement,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: counterStore.canUndo ? counterStore.undo : null,
                        child: const Text('Undo'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: counterStore.canRedo ? counterStore.redo : null,
                        child: const Text('Redo'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
```

### Methods

#### `void undo()`
Reverts the store to the previous state if available.
```dart
if (store.canUndo) {
  store.undo();
}
```

#### `void redo()`
Reapplies a reverted state if available.
```dart
if (store.canRedo) {
  store.redo();
}
```

#### `bool get canUndo`
Returns `true` if there is a previous state available for undo.

#### `bool get canRedo`
Returns `true` if there is a reverted state available for redo.

### Debugging Example
Enable debugging to trace undo/redo operations.
```dart
final store = UndoableStore<int>(0, enableDebugging: true);
store.set(1);
store.undo(); // Logs: Undo performed.
store.redo(); // Logs: Redo performed.
```

### Notes
- Ensure state changes are meaningful to avoid cluttering the undo stack.
- Limit the size of the undo stack if necessary to save memory.
