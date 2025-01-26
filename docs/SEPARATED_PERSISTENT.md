# PersistentStore

The `PersistentStore` is a specialized store that extends `BaseStore` to provide state persistence. It ensures that the store's state is saved and restored across app sessions, using mechanisms like `SharedPreferences` or other persistence solutions.

#### Features
- Save the state persistently.
- Automatically restore the state on initialization.
- Debugging support to trace state changes and persistence events.

#### Usage
```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class PersistentCounterStore extends PersistentStore<int> {
  PersistentCounterStore()
      : super(
          0, // Initial state
          persistKey: 'counter_store', // Key used for persistence
          fromJson: (json) => json as int, // Deserialization logic
          toJson: (state) => state, // Serialization logic
          enableDebugging: true, // Enable debugging
        );

  void increment() {
    set(state + 1);
  }

  void decrement() {
    set(state - 1);
  }
}
```

#### Explanation
- **Initialization:** The constructor takes the initial state, a `persistKey` to identify the store, and functions for serializing (`toJson`) and deserializing (`fromJson`) the state.
- **Persistence:**
  - `initialize()` is called internally to load persisted state during app startup.
  - `persist()` saves the current state to the persistence layer.
- **Debugging:** If `enableDebugging` is set to `true`, detailed logs about state changes and persistence events are printed.

#### Example Integration
```dart
import 'package:flutter/material.dart';
import 'path/to/persistent_counter_store.dart';

class PersistentCounterScreen extends StatelessWidget {
  const PersistentCounterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = PersistentCounterStore();

    return StoreProvider<PersistentCounterStore>(
      store: store,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Persistent Counter Example'),
        ),
        body: Center(
          child: ValueListenableBuilder(
            valueListenable: store,
            builder: (context, value, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Counter: $value',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: store.decrement,
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: store.increment,
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

#### Key Methods
- `initialize()`: Loads the persisted state and sets it in the store.
- `persist()`: Saves the current state to the persistence layer.

#### Notes
- Ensure that `persistKey` is unique for each store to avoid collisions.
- Use lightweight serialization/deserialization functions for better performance.

---

## Conclusion
The **upper_flutter_stores** package is versatile and caters to various use cases across industries. Its modular design, robust features, and developer-friendly API make it a powerful tool for managing state in Flutter applications.
