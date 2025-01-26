# Changelog

All notable changes to this project will be documented in this file.

## [0.1.0] - 2025-01-25
### Added
- Initial release of **upper_flutter_stores**.
- Core `BaseStore` class with state management functionality.
- Unified `Store` API combining multiple features into one store:
  - Undo/Redo functionality with `UndoableStore`.
  - Persistence functionality with `PersistentStore` using `SharedPreferences`.
  - Computed state functionality with `ComputedStore`.
  - Snapshot management with `SnapshotStore`.
  - Async state management with `AsyncStore`.
  - Dynamic key-value management with `DynamicStore`.
- Middleware support with `MiddlewareStore`.
- Automatic lifecycle management using `StoreLifecycleManager`.
- Debugging and tracing capabilities with `debugContext` and logging enhancements.
- Examples and documentation for various use cases:
  - Basic state management.
  - Undo/Redo, persistence, and computed stores.
  - Using middleware for custom state handling.
  - Integration with Flutter widgets and automatic resource cleanup.

## [0.1.2] - 2025-01-25
### Added
- Tracing capabilities for all stores to pinpoint the location of state changes or errors.
- `debugContext` property to provide detailed context for debugging across all stores.

### Improved
- Unified `Store` constructor with better support for debugging and lifecycle management.
- Enhanced documentation with real-world examples and middleware usage.

## [0.1.3] - 2025-01-25
### Fixed
- Resolved edge case issues in `PersistentStore` where state initialization could fail in some scenarios.
- Improved error handling and debug logs for better clarity.

## [0.1.4] - 2025-01-25
### Added
- Middleware example and documentation in `README.md`.
- Additional examples showcasing integration with Flutter widgets, automatic cleanup, and multiple features combined.
- Detailed logging for `StoreLifecycleManager`.

## [0.1.5] - 2025-01-25
### Added
- Added Example app

## [0.1.6] - 2025-01-25
### Added
- Upgraded dependencies

## [0.1.7] - 2025-01-25
### Added
- Changed Package name to avoid collision with others

## [0.1.8] - 2025-01-25
### Added
- Updated documentation github url

## [0.1.12] - 2025-01-25
### Added
- Added StoreProvided
- Added ConsumerProvider
- Added MultiStoreProvided
- Added StoreDefinition
- Added Documentation

### Improved
- Optimized `_notifyListeners` in `BaseStore` for better performance with large subscriber counts.
- Refactored individual stores to support lifecycle management and debugging seamlessly.

---

This project follows [Semantic Versioning](https://semver.org/).
