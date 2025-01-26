# Data-Driven Dashboard Case

This document demonstrates how to create a data-driven dashboard using the **upper_flutter_stores** package, adhering to its philosophy of performance, simplicity, and minimal engineering overhead. The dashboard will display dynamic data such as analytics, charts, and user metrics, and will leverage the package’s features for seamless state management.

---

## Requirements
- **Widgets**: Cards, charts, and tables to display data.
- **Features**:
  - Real-time data updates.
  - Asynchronous data fetching.
  - Support for undo/redo for user-configurable widgets.
  - Snapshots for state debugging.
- **Performance Focus**:
  - Minimize re-renders using `ValueListenableBuilder`.
  - Keep business logic within stores.

---

## Folder Structure
```
lib/
├── main.dart
├── features/
│   ├── dashboard/
│   │   ├── screens/
│   │   │   ├── dashboard_screen.dart
│   │   ├── store/
│   │   │   ├── dashboard_store.dart
│   │   ├── widgets/
│   │       ├── chart_widget.dart
│   │       ├── metrics_card.dart
│   │       ├── table_widget.dart
├── common/
│   ├── utils/
│   ├── themes/
```

---

## Step 1: Create the Store

The `DashboardStore` will manage the state for the dashboard.

```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class DashboardStore extends StoreInterface<Map<String, dynamic>> {
  DashboardStore()
      : super(
          {
            'metrics': {},
            'chartData': [],
            'tableData': [],
          },
          enableSnapshots: true,
          enableDebugging: true,
          enableUndoRedo: true,
          enablePersistence: true,
          persistKey: 'dashboard_store',
        ){
    initializePersistence();
  }

  Map<String, dynamic> get metrics => state['metrics'] ?? {};
  List<Map<String, dynamic>> get chartData => state['chartData'] ?? [];
  List<Map<String, dynamic>> get tableData => state['tableData'] ?? [];

  Future<void> fetchMetrics() async {
    final data = await fetchFromApi('/metrics'); // Simulated API call
    set({
      ...state,
      'metrics': data,
    });
  }

  Future<void> fetchChartData() async {
    final data = await fetchFromApi('/chartData'); // Simulated API call
    set({
      ...state,
      'chartData': data,
    });
  }

  Future<void> fetchTableData() async {
    final data = await fetchFromApi('/tableData'); // Simulated API call
    set({
      ...state,
      'tableData': data,
    });
  }

  Future<Map<String, dynamic>> fetchFromApi(String endpoint) async {
    await Future.delayed(Duration(seconds: 2));
    return {}; // Simulate API response
  }
}
```

---

## Step 2: Build the Dashboard Screen

The `DashboardScreen` displays data using widgets and `StoreConsumer` for reactivity.

```dart
import 'package:flutter/material.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';
import '../store/dashboard_store.dart';
import '../widgets/chart_widget.dart';
import '../widgets/metrics_card.dart';
import '../widgets/table_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dashboardStore = StoreProvider.of<DashboardStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data-Driven Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: dashboardStore.canUndo ? dashboardStore.undo : null,
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: dashboardStore.canRedo ? dashboardStore.redo : null,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: StoreConsumer<DashboardStore>(
                      builder: (context, store) => MetricsCard(metrics: store.metrics),
                    ),
                  ),
                  Expanded(
                    child: StoreConsumer<DashboardStore>(
                      builder: (context, store) => ChartWidget(data: store.chartData),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StoreConsumer<DashboardStore>(
                builder: (context, store) => TableWidget(data: store.tableData),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await dashboardStore.fetchMetrics();
          await dashboardStore.fetchChartData();
          await dashboardStore.fetchTableData();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
```

---

## Step 3: Create Widgets

### **MetricsCard**
```dart
import 'package:flutter/material.dart';

class MetricsCard extends StatelessWidget {
  final Map<String, dynamic> metrics;

  const MetricsCard({Key? key, required this.metrics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: metrics.entries.map((e) => Text('${e.key}: ${e.value}')).toList(),
        ),
      ),
    );
  }
}
```

### **ChartWidget**
```dart
import 'package:flutter/material.dart';

class ChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const ChartWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Text('Chart Placeholder with ${data.length} entries'),
      ),
    );
  }
}
```

### **TableWidget**
```dart
import 'package:flutter/material.dart';

class TableWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const TableWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Key')),
          DataColumn(label: Text('Value')),
        ],
        rows: data.map((row) => DataRow(cells: [
          DataCell(Text(row['key'] ?? '')),
          DataCell(Text(row['value'] ?? '')),
        ])).toList(),
      ),
    );
  }
}
```

---

## Conclusion
The **upper_flutter_stores** package enables you to build a responsive and efficient data-driven dashboard with minimal effort. This approach:

- Keeps the UI and state management separate.
- Supports advanced features like undo/redo and snapshots for debugging.
- Ensures clean and scalable code by leveraging stores effectively.

This architecture is highly adaptable to any real-time data-driven application.
