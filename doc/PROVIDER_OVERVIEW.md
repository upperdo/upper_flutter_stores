# Provider Overview: **upper\_flutter\_stores**

The **upper\_flutter\_stores** package includes multiple types of providers designed to facilitate state management for your Flutter applications. Each provider offers distinct functionality tailored to specific use cases. This document explains when to use each provider and why it’s recommended.

---

## Table of Contents

1. [StoreProvider](#storeprovider)
2. [StoreConsumer](#storeconsumer)
3. [MultiStoreProvider](#multistoreprovider)

---

## StoreProvider

### Overview

`StoreProvider` is the primary provider for injecting a single store into your widget tree. It allows child widgets to access and interact with the store via context.

### When to Use

- **Single Store Applications**: Use when your app manages a single store instance for its state.
- **Scoped State Management**: Use to limit the store’s visibility to a specific subtree in your widget hierarchy.

### Why Use StoreProvider?

- **Simplicity**: Provides a straightforward way to inject a single store.
- **Performance**: Reduces rebuilds by scoping state updates to specific areas of the widget tree.

### Example

```dart
StoreProvider<TodoStore>(
  store: TodoStore(),
  child: MaterialApp(
    home: TodoScreen(),
  ),
);
```

---

## StoreConsumer

### Overview

`StoreConsumer` is a widget that listens to changes in a store and rebuilds its child widgets when the store’s state changes. It’s designed to work in tandem with `StoreProvider`.

### When to Use

- **Fine-Grained Updates**: Use when a specific widget needs to rebuild only when a store’s state changes.
- **Custom Rendering**: Use to build custom UIs based on the current state of a store.

### Why Use StoreConsumer?

- **Customizability**: Allows you to define how the UI should respond to state changes.
- **Ease of Use**: Automatically handles listening to state changes and rebuilding the widget.

### Example

```dart
StoreConsumer<TodoStore>(
  builder: (context, todoStore) {
    final tasks = todoStore.tasks;
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(tasks[index]['title']),
        );
      },
    );
  },
);
```

---

## MultiStoreProvider

### Overview

`MultiStoreProvider` simplifies managing multiple stores by wrapping them in a single provider widget. It ensures all stores are accessible to the child widgets.

### When to Use

- **Applications with Multiple Stores**: Use when your app requires different stores for managing independent pieces of state.
- **Complex Widget Trees**: Use to avoid nesting multiple `StoreProvider` instances manually.

### Why Use MultiStoreProvider?

- **Cleaner Code**: Reduces boilerplate by managing multiple stores in a single widget.
- **Scalability**: Makes it easier to add or remove stores as your app grows.

### Example

```dart
MultiStoreProvider(
  definitions: [
    StoreDefinition(TodoStore()),
    StoreDefinition(SampleStore()),
  ],
  child: MaterialApp(
    home: MultiStoreExampleScreen(),
  ),
);
```

---

## Choosing the Right Provider

| **Scenario**                                | **Recommended Provider** | **Reason**                                                            |
| ------------------------------------------- | ------------------------ | --------------------------------------------------------------------- |
| Managing a single store in a small app      | StoreProvider            | Simple and efficient for injecting a single store.                    |
| Fine-grained control over widget rebuilding | StoreConsumer            | Allows you to define specific widget rebuild logic.                   |
| Managing multiple independent stores        | MultiStoreProvider       | Reduces boilerplate and ensures clean code for multiple stores.       |
| Scoped state management                     | StoreProvider            | Restricts the store’s visibility to a subtree, improving performance. |
| Custom rendering based on state             | StoreConsumer            | Gives full control over how the UI responds to store state changes.   |

---

Each provider in **upper\_flutter\_stores** is designed with specific use cases in mind, ensuring flexibility, performance, and developer convenience. Use this guide to make informed decisions about which provider to use in your application.

---

## Conclusion
The **upper_flutter_stores** package is versatile and caters to various use cases across industries. Its modular design, robust features, and developer-friendly API make it a powerful tool for managing state in Flutter applications.
