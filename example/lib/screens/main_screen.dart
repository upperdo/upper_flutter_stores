import 'package:flutter/material.dart';
import 'package:flutter_stores_example/screens/search_screen.dart';
import 'home_screen.dart';
import 'add_task_screen.dart';
import 'add_category_screen.dart';
import 'package:flutter_stores_example/todo_provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = TodoProvider.of(context).todoStore;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO App'),
        actions: [
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
              PopupMenuItem(
                  value: 'Take Snapshot', child: Text('Take Snapshot')),
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
          // Navigate to Add Category Screen
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddCategoryScreen()),
              );
            },
          ),
        ],
      ),
      body: const HomeScreen(),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: store.todoStore,
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
}
