# StoreProvider Documentation

## Overview
The `StoreProvider` is a core component of the **upper_flutter_stores** package, enabling state management by providing a single store to a subtree of widgets. It utilizes Flutter’s `InheritedWidget` to make the store accessible to any descendant widget.

## Features
- **Type-safe access**: Provides type-safe access to the store in the widget tree.
- **Reactivity**: Automatically rebuilds widgets when the store’s state changes.
- **Modularity**: Makes it easy to inject specific stores into distinct parts of the widget tree.

## Usage

### Import
First, ensure you import the necessary package:

```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';
```

### Basic Example
Wrap a part of your widget tree with `StoreProvider` to inject a specific store:

```dart
import 'package:flutter/material.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class CounterStore extends StoreInterface<int> {
  CounterStore() : super(0);

  void increment() => set(state + 1);
  void decrement() => set(state - 1);
}

void main() {
  runApp(
    StoreProvider<CounterStore>(
      store: CounterStore(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counterStore = StoreProvider.of<CounterStore>(context);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('StoreProvider Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder(
                valueListenable: counterStore,
                builder: (context, value, _) {
                  return Text('Counter: $value');
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: counterStore.decrement,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: counterStore.increment,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### API Reference
#### Constructor
```dart
const StoreProvider<T extends BaseStore>({
  required T store,
  required Widget child,
  Key? key,
})
```
- **`store`**: The instance of the store to provide.
- **`child`**: The widget subtree that can access the provided store.

#### Static Method
```dart
static T of<T extends BaseStore>(BuildContext context)
```
- Retrieves the store instance of type `T` from the nearest ancestor `StoreProvider`.
- Throws an assertion if no matching `StoreProvider` is found in the widget tree.

#### Update Behavior
The `StoreProvider` will notify its descendants only when the provided store changes.

### Best Practices
1. **Avoid nesting providers unnecessarily**:
   Use `MultiStoreProvider` when injecting multiple stores.
2. **Keep stores lightweight**:
   Stores should focus on state management and avoid UI-related logic.
3. **Combine with consumers**:
   Use `StoreConsumer` or `ValueListenableBuilder` for clean and reactive UI updates.

### Common Pitfalls
1. **Forgetting to wrap with a provider**:
   Ensure every widget accessing a store is wrapped by a `StoreProvider`.
2. **Overlapping providers**:
   Be mindful of provider scopes to avoid unintentional overrides.

## Next Steps
Explore [StoreConsumer](STORE_CONSUMER.md) to learn how to reactively consume stores in the widget tree.

For more advanced usage, refer to the [Unified Store Overview](README.md).

---

## Conclusion
The **upper_flutter_stores** package is versatile and caters to various use cases across industries. Its modular design, robust features, and developer-friendly API make it a powerful tool for managing state in Flutter applications.
