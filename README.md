# UPPER Flutter Stores 📦

UPPER Flutter Stores is a lightweight, powerful, and flexible state management solution designed to simplify your Flutter applications. Inspired by the simplicity of Svelte Stores, it provides a unified store API with specialized independent stores for advanced use cases like persistence, snapshots, undo/redo functionality, middleware, and more.

---

## 🌟 Features

- **Unified API**: Manage your application's state in a single store with optional features like persistence, undo/redo, snapshots, and async operations.
- **Independent Stores**: Modular and specific stores for specialized needs:
  - **BaseStore**: A minimal store with reactive state.
  - **AsyncStore**: Manage asynchronous tasks with built-in loading and error states.
  - **UndoableStore**: Add undo/redo functionality for state transitions.
  - **ComputedStore**: Automatically derive state based on dependencies.
  - **PersistentStore**: Save and restore state with `SharedPreferences`.
  - **SnapshotStore**: Create and replay snapshots of state.
  - **DynamicStore**: Manage key-value state dynamically.
  - **MiddlewareStore**: Add middleware for intercepting state changes.
- **Tracing and Debugging**: Track state changes, errors, and their context when debugging is enabled.
- **Integration Ready**: Wrap your application with `StoreLifecycleManager` for automatic cleanup of listeners and subscriptions.
- **No Boilerplate**: Minimal setup with extensive functionality out-of-the-box.

---

## 🔧 Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_stores: ^1.0.0
```

Run:

```bash
flutter pub get
```

---

## 🚀 Getting Started

### Unified Store Example

```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

void main() {
  final store = Store<int>(
    0, // Initial state
    enableDebugging: true, // Enable debug logs
    enableUndoRedo: true, // Add undo/redo capability
    enableSnapshots: true, // Enable snapshot functionality
    enablePersistence: true, // Persist state across app restarts
    persistKey: 'counter_store', // Key for persistence
    fromJson: (json) => json['value'] as int,
    toJson: (state) => {'value': state},
  );

  // Listen to state changes
  store.subscribe((state) {
    print('State updated: $state');
  });

  // Perform state updates
  store.set(10); // Update state
  store.undo(); // Undo last change
  store.takeSnapshot(); // Take a snapshot
  store.persist(); // Save state
}
```

---

## 💡 Advanced Usage

### 1. Async Operations

```dart
final asyncStore = AsyncStore<String>(enableDebugging: true);

asyncStore.run(() async {
  await Future.delayed(Duration(seconds: 2));
  return "Data Loaded!";
});

asyncStore.subscribe((state) {
  if (state.isLoading) {
    print("Loading...");
  } else if (state.data != null) {
    print("Data: ${state.data}");
  } else if (state.error != null) {
    print("Error: ${state.error}");
  }
});
```

### 2. Undo/Redo Functionality

```dart
final undoableStore = UndoableStore<int>(0, enableDebugging: true);

undoableStore.set(10);
undoableStore.set(20);

undoableStore.undo(); // Reverts to 10
undoableStore.redo(); // Returns to 20
```

### 3. Middleware Example

```dart
final middlewareStore = MiddlewareStore<int>(0, enableDebugging: true);

// Add a middleware to log state transitions
middlewareStore.addMiddleware((oldState, newState) {
  print("State changed from $oldState to $newState");
});

// Add another middleware for validation
middlewareStore.addMiddleware((oldState, newState) {
  if (newState < 0) {
    print("Warning: State is negative");
  }
});

// Update state
middlewareStore.set(10); // Logs: State changed from 0 to 10
middlewareStore.set(-5); // Logs: State changed from 10 to -5 and Warning: State is negative
```

### 4. Lifecycle Management with `StoreLifecycleManager`

Wrap your app with `StoreLifecycleManager` to automatically manage listeners:

```dart
StoreLifecycleManager.register(context, () {
  print("Dispose callback executed");
});
```

---

## 📋 List of Features

1. **State Management**:
   - Reactive state updates.
   - Built-in tracing for debugging.
2. **Persistence**:
   - Save and restore state with `SharedPreferences`.
3. **Undo/Redo**:
   - Built-in undo/redo stack for state transitions.
4. **Snapshots**:
   - Take, replay, and clear state snapshots.
5. **Async Operations**:
   - Manage loading, success, and error states with ease.
6. **Dynamic Key-Value State**:
   - Flexible state management for dynamic structures.
7. **Middleware**:
   - Add middleware to intercept and process state changes.
8. **Computed State**:
   - Automatically calculate state based on dependencies.

---

## 🛠 Debugging and Tracing

Enable debugging with `enableDebugging: true` in any store. It provides:

- Logs of state transitions.
- Errors with stack traces.
- Context tracking to locate the source of changes.

---

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## 📝 Changelog

See the [CHANGELOG.md](CHANGELOG.md) for the list of updates and improvements.

---

## 💬 Feedback and Contributions

We’d love your feedback! Feel free to open issues or contribute to the repository.

---

## 🧪 Tests

This package comes with extensive unit tests to ensure reliability. Run tests with:

```bash
flutter test
```

---

## 📚 Documentation

Check the [full documentation](https://github.com/upper/upper_flutter_stores) for more details and advanced examples.
