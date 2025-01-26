# ComputedStore

The `ComputedStore` enables reactive computations based on other stores' states. This is useful for deriving new state values that depend on one or more independent stores, ensuring the computed state updates automatically whenever the dependencies change.

#### Key Features
- Automatically computes derived state based on dependencies.
- Simplifies state management for computed values.
- Reduces redundant logic by centralizing derived state in the `ComputedStore`.

#### Example Usage

```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class CounterStore extends BaseStore<int> {
  CounterStore() : super(0);

  void increment() => set(state + 1);
  void decrement() => set(state - 1);
}

class ComputedExampleStore extends ComputedStore<int> {
  ComputedExampleStore(
    CounterStore counterStore,
  ) : super(
          initialState: 0,
          compute: () => counterStore.state * 2,
          dependencies: [counterStore],
          enableDebugging: true,
        );
}

void main() {
  final counterStore = CounterStore();
  final computedStore = ComputedExampleStore(counterStore);

  computedStore.addListener(() {
    print('Computed state: ${computedStore.state}');
  });

  counterStore.increment(); // Output: Computed state: 2
  counterStore.increment(); // Output: Computed state: 4
}
```

#### Constructor Parameters
- `initialState`: The initial state of the `ComputedStore`.
- `compute`: A function that derives the computed state.
- `dependencies`: A list of stores whose state changes trigger recomputation.
- `enableDebugging`: Optional. Enables debugging logs for state updates.

#### Methods and Properties
- **`state`**: The computed state, derived automatically based on dependencies.
- **`addListener(VoidCallback listener)`**: Registers a listener for state changes.
- **`removeListener(VoidCallback listener)`**: Removes a registered listener.

#### Notes
- ComputedStores are read-only; you cannot directly update their state. Instead, modify the state of their dependencies to trigger recomputation.
- The `compute` function is called whenever any dependency's state changes, ensuring the computed value remains up to date.

The `ComputedStore` is ideal for scenarios where you need to derive reactive state based on multiple other stores, reducing complexity and promoting cleaner architecture.
