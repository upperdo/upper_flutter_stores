# API Reference: **upper_flutter_stores**

This document provides a comprehensive overview of the API definitions, interfaces, and core components available in the **upper_flutter_stores** package.

---

## Overview
The **upper_flutter_stores** package provides a structured and flexible API to manage application state efficiently. The package includes key classes, interfaces, and utilities for state management, middleware, persistence, and more.

---

## Core Interfaces and Classes

### 1. `BaseStore<T>`
#### Description:
The foundational class for state management, offering basic functionality for handling state and notifying listeners.

#### Key Methods:
- **`T get state`**: Retrieves the current state.
- **`void set(T newState)`**: Updates the state and notifies listeners.
- **`void addListener(void Function() listener)`**: Registers a listener for state changes.
- **`void removeListener(void Function() listener)`**: Unregisters a listener.

---

### 2. `Store<T>`
#### Description:
A unified store that integrates advanced features like undo/redo, persistence, snapshots, and computed values.

#### Key Features:
- Undo/Redo functionality.
- Persistence support.
- Middleware integration.
- Snapshot and replay support.

#### Key Methods:
- **`void undo()`**: Reverts to the previous state.
- **`void redo()`**: Restores the last undone state.
- **`Future<void> persist()`**: Saves the current state persistently.
- **`void takeSnapshot()`**: Captures the current state as a snapshot.
- **`void replaySnapshot(int index)`**: Reverts to a specific snapshot.

---

### 3. `StoreInterface<T>`
#### Description:
An abstract base interface for creating custom stores with specific features.

#### Key Methods:
- **`T get state`**: Retrieves the current state.
- **`void set(T newState)`**: Updates the state.
- **`Future<void> initializePersistence()`**: Initializes persistent storage for the state.
- **`void undo()`**, **`void redo()`**: Undo/redo functionality for state changes.
- **`void takeSnapshot()`**, **`void replaySnapshot(int index)`**: Snapshot management.

---

### 4. `StoreProvider<T>`
#### Description:
An InheritedWidget for injecting a store into the widget tree.

#### Key Methods:
- **`static T of<T extends BaseStore>(BuildContext context)`**: Retrieves the store of type `T` from the widget tree.

---

### 5. `StoreConsumer<T>`
#### Description:
A widget that listens to store changes and rebuilds its child widget.

#### Key Parameters:
- **`Widget Function(BuildContext context, T store)`**: A builder function that rebuilds on state changes.

---

### 6. `MultiStoreProvider`
#### Description:
A utility for injecting multiple stores into the widget tree.

#### Key Parameters:
- **`List<BaseStoreDefinition> definitions`**: A list of store definitions to provide.
- **`Widget child`**: The child widget to wrap with providers.

---

### 7. `Middleware<T>`
#### Description:
A function that intercepts state transitions, allowing pre-processing or validation.

#### Function Signature:
```dart
typedef Middleware<T> = void Function(T oldState, T newState);
```

---

## Advanced Features

### 1. Persistence
#### Description:
Provides a mechanism to persist state using `SharedPreferences` or other storage backends.

#### Key Classes:
- **`PersistentStore<T>`**: A store that saves and restores state persistently.
- **`Store<T>`**: Unified store with built-in persistence support.

#### Key Methods:
- **`Future<void> initialize()`**: Initializes persistent storage.
- **`Future<void> persist()`**: Saves the current state.

---

### 2. Undo/Redo
#### Description:
Tracks state history for reverting or reapplying changes.

#### Key Classes:
- **`UndoableStore<T>`**: Adds undo/redo capabilities to a store.
- **`Store<T>`**: Unified store with built-in undo/redo support.

#### Key Methods:
- **`void undo()`**: Reverts to the previous state.
- **`void redo()`**: Restores the last undone state.

---

### 3. Snapshots
#### Description:
Allows capturing and replaying state snapshots for debugging or time travel.

#### Key Classes:
- **`SnapshotStore<T>`**: Enables snapshot management.
- **`Store<T>`**: Unified store with snapshot support.

#### Key Methods:
- **`void takeSnapshot()`**: Captures the current state as a snapshot.
- **`void replaySnapshot(int index)`**: Restores a specific snapshot.

---

### 4. Async State Management
#### Description:
Manages asynchronous tasks and updates state upon completion.

#### Key Classes:
- **`AsyncStore<T>`**: Handles async operations.
- **`Store<T>`**: Unified store with async support.

#### Key Methods:
- **`Future<void> runAsync(Future<T> Function() task)`**: Runs an async task and updates the state on completion.

---

### 5. Computed State
#### Description:
Automatically calculates derived state based on dependencies.

#### Key Classes:
- **`ComputedStore<T>`**: Computes derived state.
- **`Store<T>`**: Unified store with computed state support.

#### Key Parameters:
- **`T Function()`**: A function to compute the derived state.
- **`List<BaseStore>`**: Dependencies for the computed state.

---

## Store Definitions
### `BaseStoreDefinition` and `StoreDefinition`
#### Description:
Used with `MultiStoreProvider` to define stores and wrap widgets with their respective providers.

#### Example:
```dart
final definitions = [
  StoreDefinition(TodoStore()),
  StoreDefinition(SampleStore()),
];

MultiStoreProvider(
  definitions: definitions,
  child: MyApp(),
);
```

---

## Conclusion
The **upper_flutter_stores** package offers a flexible and powerful API for state management. With its modular design, advanced features, and intuitive interface, it simplifies building robust Flutter applications.
