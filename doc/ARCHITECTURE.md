# Architecture: **upper_flutter_stores**

The **upper_flutter_stores** package is designed with flexibility, modularity, and extensibility in mind. It provides a robust foundation for managing application state in Flutter projects, allowing developers to handle complex scenarios while maintaining simplicity.

## Core Principles

1. **Separation of Concerns**:
   - The architecture separates core functionalities into distinct stores and components.
   - Unified and separated stores ensure modularity and focus on specific responsibilities.

2. **Scalability**:
   - The package supports both small-scale and large-scale applications by allowing developers to pick only the features they need.

3. **Reusability**:
   - Components like middleware and snapshot mechanisms are designed to be reusable across multiple stores.

4. **Developer Experience**:
   - Minimal boilerplate and intuitive APIs make it easy for developers to integrate and use the package.

---

## Key Components

### 1. Unified Store
- **Purpose**: Combines multiple features (e.g., persistence, undo/redo, async operations) into a single store for convenience.
- **Features**:
  - Supports state persistence using `PersistentStore`.
  - Allows undo/redo actions via `UndoableStore`.
  - Handles computed states with `ComputedStore`.
  - Enables asynchronous operations through `AsyncStore`.
  - Provides snapshot and replay functionality with `SnapshotStore`.
- **Usage**: Ideal for most scenarios where multiple features are required in a single store.

### 2. Separated Stores
- **Purpose**: Provide feature-specific implementations for advanced control and specialization.
- **Examples**:
  - `BaseStore`: Core state management.
  - `UndoableStore`: Adds undo/redo functionality.
  - `PersistentStore`: Manages state persistence.
  - `AsyncStore`: Handles asynchronous updates.
  - `ComputedStore`: Manages derived state calculations.
  - `SnapshotStore`: Enables state snapshots and replay.
- **Usage**: Suitable for use cases requiring granular control over individual features.

### 3. Store Providers
- **`StoreProvider`**:
  - A generic provider that injects a store into the widget tree.
  - Allows child widgets to access the store via the context.
- **`MultiStoreProvider`**:
  - Enables injecting multiple stores into the widget tree simultaneously.
  - Simplifies dependency management for widgets requiring multiple stores.

### 4. Middleware
- **Purpose**: Intercepts state transitions, enabling custom logic (e.g., logging, validation).
- **Integration**: Middleware can be added to unified stores or specific separated stores.

---

## Data Flow

The package follows a unidirectional data flow pattern:

1. **State Update**:
   - State changes are triggered via `set` or feature-specific methods (e.g., `undo`, `takeSnapshot`).

2. **Middleware Interception**:
   - Middleware intercepts state transitions, allowing additional logic to be executed.

3. **Reactivity**:
   - Changes in state automatically notify listeners, ensuring the UI reflects the updated state.

4. **Persistence** (if enabled):
   - State changes are saved to local storage, ensuring data is retained across sessions.

---

## Reactivity and Notifications

- Stores inherit from `BaseStore`, which implements `ChangeNotifier` to provide reactivity.
- Changes to state trigger notifications to listeners, ensuring widgets depending on the state rebuild as needed.

---

## Design Decisions

### Modular Design
- Stores are designed as independent modules, allowing developers to use them individually or as part of the unified store.

### Extensibility
- Developers can extend existing stores or create custom implementations by inheriting from `BaseStore` or other specialized stores.

### Lightweight and Efficient
- The package avoids unnecessary dependencies, focusing on performance and simplicity.

---

## Conclusion

The **upper_flutter_stores** package provides a comprehensive and flexible state management solution tailored to the needs of modern Flutter applications. Its modular architecture and focus on scalability make it a powerful tool for developers, whether building small apps or enterprise-level solutions.
