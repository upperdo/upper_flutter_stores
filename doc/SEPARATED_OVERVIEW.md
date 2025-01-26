# Separated Store Overview

**Separated Stores** in the `upper_flutter_stores` package provide a modular and specialized approach to store management. These stores focus on individual features or functionalities, offering advanced capabilities tailored to specific needs.

### Benefits of Using Separated Stores
- **Granular Control**: Each store is designed for a specific purpose, making it easier to focus on the feature at hand.
- **Reusability**: Feature-specific stores can be reused across projects.
- **Advanced Capabilities**: Gain access to specialized features like undo/redo, snapshots, and computed values without managing everything manually.
- **Scalability**: Adopt only the stores you need without including unnecessary overhead.

### List of Separated Stores
Here is a list of the separated stores available in the `upper_flutter_stores` package:

1. **[BaseStore](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/SEPARATED_BASE.md)**: The foundational store that provides core functionality for state management.
2. **[UndoableStore](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/SEPARATED_UNDOABLE.md)**: Adds undo/redo functionality to your state management.
3. **[PersistentStore](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/SEPARATED_PERSISTENT.md)**: Enables persistence of state across app sessions using local storage.
4. **[AsyncStore](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/SEPARATED_ASYNC.md)**: Handles asynchronous state updates, such as network requests or time-based updates.
5. **[ComputedStore](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/SEPARATED_COMPUTED.md)**: Computes derived state based on dependencies, automatically recalculating when dependencies change.
6. **[SnapshotStore](https://github.com/upperdo/upper_flutter_stores/blob/master/doc/SEPARATED_SNAPSHOTS.md)**: Allows taking and replaying snapshots of the state for debugging or temporal operations.

Each store can be used independently or integrated into the `Store` class for a unified experience.

---

## Conclusion
The **upper_flutter_stores** package is versatile and caters to various use cases across industries. Its modular design, robust features, and developer-friendly API make it a powerful tool for managing state in Flutter applications.
