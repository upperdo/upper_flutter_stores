# Enterprise Application Case Study

This document outlines the implementation of an enterprise-level application using the **upper_flutter_stores** package. The focus is on delivering high performance, maintaining simplicity, and avoiding overengineering while managing complex state logic efficiently.

---

## Objective

To demonstrate how to use **upper_flutter_stores** to build a scalable enterprise app that:

- Supports complex workflows.
- Integrates seamlessly with APIs and other services.
- Provides a robust, user-friendly experience.
- Maintains high performance and minimal boilerplate.

---

## Application Overview

### Features
- **Multi-User Access:** Role-based functionality for administrators, managers, and employees.
- **Data Analytics:** Real-time dashboards for business insights.
- **Offline Support:** Data synchronization when the app is back online.
- **Custom Workflows:** Dynamic forms and approval processes.

### Architecture

We recommend the **Feature-First Architecture** as outlined in the [Suggested Architecture](https://github.com/upperdo/upper_flutter_stores/blob/main/docs/SUGGESTED_ARCHITECTURE.md) document.

---

## Folder Structure

```plaintext
lib/
├── main.dart
├── features/
│   ├── dashboard/
│   │   ├── screens/
│   │   ├── store/
│   │   ├── models/
│   │   └── services/
│   ├── user_management/
│   │   ├── screens/
│   │   ├── store/
│   │   ├── models/
│   │   └── services/
│   └── approvals/
│       ├── screens/
│       ├── store/
│       ├── models/
│       └── services/
├── common/
│   ├── widgets/
│   ├── utils/
│   └── themes/
```

---

## Implementation Details

### 1. **Dashboard Feature**

#### **State Management**

```dart
class DashboardStore extends StoreInterface<Map<String, dynamic>> {
  DashboardStore()
      : super(
          {'metrics': []},
          enablePersistence: true,
          persistKey: 'dashboard_data',
        ){
    initializePersistence();
  }

  List<Map<String, dynamic>> get metrics => List<Map<String, dynamic>>.from(state['metrics']);

  void updateMetrics(List<Map<String, dynamic>> newMetrics) {
    set({'metrics': newMetrics});
  }
}
```

#### **Integration with API**

```dart
class DashboardService {
  final ApiClient _client;

  DashboardService(this._client);

  Future<List<Map<String, dynamic>>> fetchMetrics() async {
    final response = await _client.get('/metrics');
    return List<Map<String, dynamic>>.from(response['data']);
  }
}
```

#### **UI Example**

```dart
class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<DashboardStore>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: StoreConsumer<DashboardStore>(
        builder: (context, store) {
          final metrics = store.metrics;

          if (metrics.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          return ListView.builder(
            itemCount: metrics.length,
            itemBuilder: (context, index) {
              final metric = metrics[index];
              return ListTile(
                title: Text(metric['name']),
                subtitle: Text('Value: ${metric['value']}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final service = DashboardService(ApiClient());
          final data = await service.fetchMetrics();
          store.updateMetrics(data);
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
```

---

### 2. **User Management Feature**

#### **State Management**

```dart
class UserStore extends StoreInterface<Map<String, dynamic>> {
  UserStore()
      : super(
          {'users': []},
          enablePersistence: true,
          persistKey: 'user_data',
        ){
    initializePersistence();
  }

  List<Map<String, dynamic>> get users => List<Map<String, dynamic>>.from(state['users']);

  void addUser(Map<String, dynamic> user) {
    final updatedUsers = [...users, user];
    set({'users': updatedUsers});
  }

  void removeUser(int index) {
    final updatedUsers = [...users]..removeAt(index);
    set({'users': updatedUsers});
  }
}
```

#### **UI Example**

```dart
class UserManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<UserStore>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('User Management')),
      body: StoreConsumer<UserStore>(
        builder: (context, store) {
          final users = store.users;

          if (users.isEmpty) {
            return const Center(child: Text('No users available'));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user['name']),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => store.removeUser(index),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newUser = {'name': 'New User ${store.users.length + 1}'};
          store.addUser(newUser);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

---

### Best Practices

1. **Use Persistence Sparingly**:
   - Persist only critical data to avoid unnecessary I/O operations.

2. **Leverage Snapshots for Debugging**:
   - Use snapshots during development to identify issues.

3. **Optimize Middleware**:
   - Implement middleware for logging and validation.

4. **Avoid Overengineering**:
   - Focus on simplicity, using features only as needed.

---

This case study demonstrates how to use **upper_flutter_stores** effectively in an enterprise environment. It balances performance, simplicity, and scalability for real-world applications.
