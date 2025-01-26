# Banking App Case Study with **upper_flutter_stores**

This case study demonstrates how to build a robust, scalable, and high-performance banking application using the **upper_flutter_stores** package. The goal is to balance performance and simplicity while adhering to the philosophy of avoiding over-engineering.

---

## Key Features of the Banking App

1. **User Account Management**:
   - View account balances and transaction history.
   - Manage multiple accounts (e.g., savings, checking, credit).

2. **Money Transfers**:
   - Perform secure money transfers between accounts or to other users.

3. **Notifications**:
   - Notify users of successful transfers and account updates.

4. **Offline Mode**:
   - View cached account data when offline.

5. **Security**:
   - Use middleware for token validation and error handling.

---

## Folder Structure

```
lib/
├── main.dart
├── features/
│   ├── accounts/
│   │   ├── screens/
│   │   │   ├── account_summary_screen.dart
│   │   │   ├── transaction_history_screen.dart
│   │   ├── store/
│   │   │   └── account_store.dart
│   │   ├── services/
│   │   │   └── account_service.dart
│   │   ├── models/
│   │   │   └── account_model.dart
│   ├── transfers/
│   │   ├── screens/
│   │   │   ├── transfer_screen.dart
│   │   ├── store/
│   │   │   └── transfer_store.dart
│   │   ├── services/
│   │   │   └── transfer_service.dart
│   │   ├── models/
│   │   │   └── transfer_model.dart
├── common/
│   ├── widgets/
│   ├── utils/
│   ├── themes/
```

---

## Implementation Details

### 1. Unified Store for Account Management

**File**: `features/accounts/store/account_store.dart`

```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class AccountStore extends StoreInterface<Map<String, dynamic>> {
  AccountStore()
      : super(
          {
            'accounts': [],
            'selectedAccount': null,
          },
          enablePersistence: true,
          persistKey: 'account_store',
        ){
    initializePersistence();
  }

  List<Map<String, dynamic>> get accounts => List.from(state['accounts'] ?? []);

  Map<String, dynamic>? get selectedAccount => state['selectedAccount'];

  void loadAccounts(List<Map<String, dynamic>> newAccounts) {
    set({
      ...state,
      'accounts': newAccounts,
    });
  }

  void selectAccount(Map<String, dynamic> account) {
    set({
      ...state,
      'selectedAccount': account,
    });
  }
}
```

### 2. Unified Store for Money Transfers

**File**: `features/transfers/store/transfer_store.dart`

```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class TransferStore extends StoreInterface<Map<String, dynamic>> {
  TransferStore()
      : super(
          {
            'transferHistory': [],
          },
          enableSnapshots: true,
        );

  List<Map<String, dynamic>> get transferHistory => List.from(state['transferHistory'] ?? []);

  void addTransfer(Map<String, dynamic> transfer) {
    final updatedHistory = [...transferHistory, transfer];
    set({
      ...state,
      'transferHistory': updatedHistory,
    });
    takeSnapshot(); // For debugging or temporal use cases
  }
}
```

### 3. MultiStoreProvider Example

**File**: `main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';
import 'features/accounts/store/account_store.dart';
import 'features/transfers/store/transfer_store.dart';
import 'features/accounts/screens/account_summary_screen.dart';

void main() {
  runApp(const BankingApp());
}

class BankingApp extends StatelessWidget {
  const BankingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiStoreProvider(
      definitions: [
        StoreDefinition<AccountStore>(AccountStore()),
        StoreDefinition<TransferStore>(TransferStore()),
      ],
      child: MaterialApp(
        title: 'Banking App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const AccountSummaryScreen(),
      ),
    );
  }
}
```

### 4. Middleware for Security

**File**: `features/accounts/store/account_store.dart`

```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class SecurityMiddleware extends Middleware<Map<String, dynamic>> {
  @override
  void call(Map<String, dynamic> oldState, Map<String, dynamic> newState) {
    if (newState['selectedAccount'] == null) {
      print('Warning: Attempted to access a null account.');
    }
  }
}
```

### 5. Account Summary Screen

**File**: `features/accounts/screens/account_summary_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';
import '../store/account_store.dart';

class AccountSummaryScreen extends StatelessWidget {
  const AccountSummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConsumer<AccountStore>(
      builder: (context, accountStore) {
        final accounts = accountStore.accounts;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Account Summary'),
          ),
          body: ListView.builder(
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];
              return ListTile(
                title: Text(account['name'] ?? 'Account ${index + 1}'),
                subtitle: Text('Balance: \$${account['balance']}'),
                onTap: () => accountStore.selectAccount(account),
              );
            },
          ),
        );
      },
    );
  }
}
```

---

## Summary

The **upper_flutter_stores** package simplifies state management for banking applications by:

- **Encouraging modularity** with features like `StoreInterface` and `MultiStoreProvider`.
- **Reducing boilerplate** for common operations like persistence and snapshots.
- **Improving security** through middleware for runtime checks.

By following this structure, you can develop a high-performance and maintainable banking app without over-engineering.
