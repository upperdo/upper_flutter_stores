import 'package:flutter/material.dart';
import 'package:flutter_stores_example/screens/consumer_example_screen.dart';
import 'package:flutter_stores_example/screens/multi_store_provider_screen.dart';
import 'package:flutter_stores_example/screens/search_screen.dart';
import 'package:flutter_stores_example/store/todo_store.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';
import 'home_screen.dart';
import 'add_task_screen.dart';
import 'add_category_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<TodoStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO App'),
        actions: buildActions(store, context),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(child: HomeScreen()),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ConsumerExampleScreen()),
                    );
                  },
                  child: const Text('Go to Consumer Example Screen'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const MultiStoreProviderScreen()),
                    );
                  },
                  child: const Text('Go to MultiStoreProvider Example Screen'),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: store,
        builder: (context, value, _) {
          final pendingTasks =
              store.tasks.where((task) => task['done'] != true).toList();
          final taskCount = pendingTasks.length;
          return FloatingActionButton.extended(
            onPressed: null, // The counter is not actionable
            label: Text('Tasks: $taskCount'),
            icon: const Icon(Icons.task),
          );
        },
      ),
    );
  }

  List<Widget> buildActions(TodoStore store, BuildContext context) {
    return [
      PopupMenuButton<String>(
        onSelected: (value) {
          switch (value) {
            case 'Undo':
              store.undo();
              break;
            case 'Redo':
              store.redo();
              break;
            case 'Take Snapshot':
              store.takeSnapshot();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Snapshot taken!')),
              );
              break;
          }
        },
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'Undo', child: Text('Undo')),
          PopupMenuItem(value: 'Redo', child: Text('Redo')),
          PopupMenuItem(value: 'Take Snapshot', child: Text('Take Snapshot')),
        ],
      ),
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SearchScreen()),
          );
        },
      ),
      IconButton(
        icon: const Icon(Icons.add_task),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
        },
      ),
      IconButton(
        icon: const Icon(Icons.category),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddCategoryScreen()),
          );
        },
      ),
    ];
  }
}
