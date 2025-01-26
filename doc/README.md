# Documentation: **upper_flutter_stores**

## Table of Contents

1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Features Overview](#features-overview)
   - [Unified Store Overview](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/UNIFIED_STORE.md)
   - [Provider Overview](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/PROVIDER_OVERVIEW.md)
   - [StoreProvider](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/STORE_PROVIDER.md)
   - [StoreConsumer](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/STORE_CONSUMER.md)
   - [MultiStoreProvider](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/MULTISTORE_PROVIDER.md)
   - [Undo/Redo Functionality](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/UNIFIED_UNDO_REDO.md)
   - [Snapshots and Replay](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/UNIFIED_SNAPSHOTS.md)
   - [Persistence](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/UNIFIED_PERSISTENCE.md)
   - [Middleware](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/UNIFIED_MIDDLEWARE.md)
   - [Separated Overview Store](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/SEPARATED_OVERVIEW.md)
   4. [Architecture](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/ARCHITECTURE.md)
   5. [Suggested Architecture](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/SUGGESTED_ARCHITECTURE.md)
   6. [Use Cases](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/USE_CASES.md)
   7. [API Definition](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/API_DEFINITION.md)
8. [Comparison with Other Solutions](#comparison-with-other-solutions)
---

## Introduction

The **upper_flutter_stores** package is a robust and user-friendly state management solution for Flutter applications. Inspired by simplicity and extensibility, it provides:

- Unified state management for various types of stores (e.g., persistent, undoable, async).
- Support for snapshots and reactivity out of the box.
- Multi-store provider for seamless dependency injection.
- Middleware capabilities for intercepting and enhancing state transitions.
- A developer-friendly API for minimal boilerplate and maximum productivity.

---

## Installation

To use **upper_flutter_stores**, add the package to your `pubspec.yaml` file:

```yaml
dependencies:
  upper_flutter_stores: latest
```

Then run:

```bash
flutter pub get
```

---

## Features Overview

The **upper_flutter_stores** package offers:

1. **[Unified Store Overview](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/UNIFIED_STORE.md)**: A single store encapsulating multiple functionalities such as persistence, undo/redo, snapshots, and more.
2. **[StoreProvider](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/STORE_PROVIDER.md)**: Dependency injection for state management.
3. **[StoreConsumer](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/STORE_CONSUMER.md)**: Simplifies accessing the store in the widget tree.
4. **[MultiStoreProvider](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/MULTISTORE_PROVIDER.md)**: Manage multiple stores seamlessly.
5. **[Undo/Redo Functionality](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/UNIFIED_UNDO_REDO.md)**: Enables undoing and redoing state changes easily.
6. **[Snapshots and Replay](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/UNIFIED_SNAPSHOTS.md)**: Allows state snapshots and replay for debugging and more.
7. **[Persistence](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/UNIFIED_PERSISTENCE.md)**: Save and restore state across app sessions.
8. **[Middleware](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/UNIFIED_MIDDLEWARE.md)**: Intercept and enhance state transitions.
9. **[Separated Overview Store](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/SEPARATED_OVERVIEW.md)**: A modular approach for specific state management features.

---

## Architecture

Learn about the architectural philosophy and design principles behind **upper_flutter_stores** in the [Architecture Guide](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/ARCHITECTURE.md).

---

## API Definition

For a detailed overview of available classes, methods, and their usage, refer to the [API Definition](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/API_DEFINITION.md).

---

## Comparison with Other Solutions

| Feature                          | upper_flutter_stores          | Provider/InheritedWidget | Riverpod                  | Bloc/Cubit                 |
|----------------------------------|--------------------------------|--------------------------|---------------------------|----------------------------|
| Unified Store                    | **Yes**                       | No                       | No                        | No                         |
| Multi-Store Support              | **Yes**                       | Limited                  | **Yes**                   | Limited                    |
| Middleware                       | **Yes**                       | No                       | No                        | Limited                    |
| Undo/Redo                        | **Yes**                       | No                       | No                        | No                         |
| Persistence                      | **Yes**                       | No                       | Limited                   | No                         |
| Snapshots and Replay             | **Yes**                       | No                       | No                        | No                         |
| Ease of Use                      | **High**                      | Moderate                 | High                      | Low                        |
| Boilerplate                      | **Minimal**                   | Minimal                  | Minimal                   | **High**                   |
| Extensibility                    | **High**                      | Limited                  | High                      | Limited                    |

**Note**: This table highlights key differences and strengths of **upper_flutter_stores** compared to popular Flutter state management solutions.

---
