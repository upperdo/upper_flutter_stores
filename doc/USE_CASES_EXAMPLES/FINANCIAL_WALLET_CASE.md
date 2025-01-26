# Financial Wallet Case Study with `upper_flutter_stores`

This guide demonstrates how to build a simple and performant financial wallet application using the `upper_flutter_stores` package. We will focus on maintaining performance, ease of use, and avoiding over-engineering.

---

## **Overview**
In this financial wallet case, the app will manage:

1. User balances and transactions.
2. Transaction history.
3. Categories for spending.
4. Reactive updates for changes in balances or new transactions.

### **Key Features**
- **State Persistence**: Ensure user data persists across sessions.
- **Undo/Redo**: Allow reverting accidental changes (e.g., removing a transaction).
- **Performance Focus**: Efficient updates to state without redundant computations.
- **Ease of Use**: Simple and modular code structure.

---

## **Folder Structure**
Here's the suggested folder structure for this use case:

```
lib/
├── main.dart
├── features/
│   └── wallet/
│       ├── store/
│       │   ├── wallet_store.dart
│       │   ├── category_store.dart
│       ├── models/
│       │   ├── transaction_model.dart
│       │   ├── category_model.dart
│       ├── screens/
│       │   ├── wallet_screen.dart
│       │   ├── add_transaction_screen.dart
│       │   ├── category_screen.dart
```

---

## **Implementation**

### **1. Wallet Store**
The `WalletStore` manages the user's balance and transactions.

```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class WalletStore extends StoreInterface<Map<String, dynamic>> {
  WalletStore()
      : super(
          {
            'balance': 0.0,
            'transactions': [],
          },
          enablePersistence: true,
          persistKey: 'wallet_store',
          toJson: (state) => state,
          fromJson: (json) => {
            'balance': json['balance'] ?? 0.0,
            'transactions': List<Map<String, dynamic>>.from(json['transactions'] ?? []),
          },
        ){
    initializePersistence();
  }

  double get balance => state['balance'];

  List<Map<String, dynamic>> get transactions => state['transactions'];

  void addTransaction(Map<String, dynamic> transaction) {
    final updatedTransactions = [...transactions, transaction];
    final updatedBalance = balance + (transaction['amount'] ?? 0.0);

    set({
      'balance': updatedBalance,
      'transactions': updatedTransactions,
    });
  }

  void removeTransaction(int index) {
    final updatedTransactions = List<Map<String, dynamic>>.from(transactions);
    final removedTransaction = updatedTransactions.removeAt(index);
    final updatedBalance = balance - (removedTransaction['amount'] ?? 0.0);

    set({
      'balance': updatedBalance,
      'transactions': updatedTransactions,
    });
  }
}
```

### **2. Transaction Model**
Define a model for transactions to ensure type safety.

```dart
class TransactionModel {
  final String description;
  final double amount;
  final DateTime date;

  TransactionModel({
    required this.description,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'description': description,
        'amount': amount,
        'date': date.toIso8601String(),
      };

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      description: json['description'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
    );
  }
}
```

### **3. Wallet Screen**
The main screen displays the wallet balance and transaction history.

```dart
import 'package:flutter/material.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';
import '../store/wallet_store.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final walletStore = StoreProvider.of<WalletStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
      ),
      body: ValueListenableBuilder(
        valueListenable: walletStore,
        builder: (context, _, __) {
          return Column(
            children: [
              Text('Balance: \$${walletStore.balance.toStringAsFixed(2)}'),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: walletStore.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = walletStore.transactions[index];
                    return ListTile(
                      title: Text(transaction['description'] ?? ''),
                      subtitle: Text(
                          '\$${transaction['amount'].toStringAsFixed(2)} on ${transaction['date']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => walletStore.removeTransaction(index),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Navigate to Add Transaction Screen
        },
      ),
    );
  }
}
```

### **4. Add Transaction Screen**

```dart
import 'package:flutter/material.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';
import '../store/wallet_store.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final walletStore = StoreProvider.of<WalletStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final transaction = {
                  'description': _descriptionController.text,
                  'amount': double.tryParse(_amountController.text) ?? 0.0,
                  'date': DateTime.now().toIso8601String(),
                };
                walletStore.addTransaction(transaction);
                Navigator.pop(context);
              },
              child: const Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## **Conclusion**
This approach ensures:

1. **Performance**: Efficient updates and persistence with minimal boilerplate.
2. **Ease of Use**: Straightforward APIs for state management.
3. **Extensibility**: Easy to add new features like categories or analytics.

With `upper_flutter_stores`, building scalable and maintainable applications is simpler and more productive.
