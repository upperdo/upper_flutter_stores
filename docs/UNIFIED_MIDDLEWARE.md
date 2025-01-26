# Middleware in **upper_flutter_stores**

Middleware in the **upper_flutter_stores** package allows you to intercept state changes, enabling logging, validation, analytics, or any custom behavior before or after state transitions. Middleware can be applied to both unified and separated stores, providing flexibility and control over state management.

---

## Using Middleware in Unified Stores

Middleware can be added to unified stores to intercept and process state changes. This is useful for debugging, validation, or enhancing the state management flow.

### Adding Middleware to a Unified Store

Here is an example of adding middleware to a unified store:

```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class TodoStore extends StoreInterface<Map<String, dynamic>> {
  TodoStore()
      : super(
          {
            'tasks': <Map<String, dynamic>>[],
            'categories': <String>['General'],
          },
          enableDebugging: true,
        ) {
    setupMiddleware();
  }

  void setupMiddleware() {
    store.addMiddleware((oldState, newState) {
      print('Middleware: State changed from $oldState to $newState');
    });
  }

  void addTask(Map<String, dynamic> task) {
    final updatedTasks = [...tasks, task];
    set({
      ...state,
      'tasks': updatedTasks,
    });
  }

  List<Map<String, dynamic>> get tasks => state['tasks'] ?? [];
}
```

### Middleware Signature

Middleware functions in **upper_flutter_stores** have the following signature:

```dart
typedef Middleware<T> = void Function(T oldState, T newState);
```

- **`oldState`**: The state before the change.
- **`newState`**: The state after the change.

### Adding Multiple Middleware

You can add multiple middleware functions to the same store. Each middleware function is executed in the order it was added.

```dart
store.addMiddleware((oldState, newState) {
  print('First middleware: $oldState -> $newState');
});

store.addMiddleware((oldState, newState) {
  print('Second middleware: $oldState -> $newState');
});
```

---

## Removing Middleware

If needed, you can remove middleware from a store.

```dart
final middleware = (oldState, newState) {
  print('Middleware logic here');
};

store.addMiddleware(middleware);
store.removeMiddleware(middleware);
```

---

## Practical Use Cases

### 1. Logging State Changes
Middleware is often used for logging state transitions to help with debugging.

```dart
store.addMiddleware((oldState, newState) {
  print('State changed from $oldState to $newState');
});
```

### 2. Validation
Validate the new state before applying it.

```dart
store.addMiddleware((oldState, newState) {
  if (newState['tasks'] == null) {
    throw Exception('Tasks cannot be null');
  }
});
```

### 3. Analytics
Track user interactions or state changes for analytics.

```dart
store.addMiddleware((oldState, newState) {
  analyticsService.track('StateChange', {
    'oldState': oldState,
    'newState': newState,
  });
});
```

---

## Conclusion

Middleware is a powerful feature in **upper_flutter_stores** that allows you to enhance and control the behavior of your state management. Whether you're debugging, validating, or integrating analytics, middleware provides a flexible way to intercept and process state transitions.

For more advanced configurations, refer to the documentation on [Unified Store Overview](UNIFIED_STORE_OVERVIEW.md).
