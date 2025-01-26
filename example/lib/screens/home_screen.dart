import 'package:flutter/material.dart';
import 'package:flutter_stores_example/store/todo_store.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<TodoStore>(context);

    return ValueListenableBuilder(
      valueListenable: store,
      builder: (context, value, _) {
        final tasks = store.tasks;
        if (!store.hasTasks) {
          return const Center(child: Text('No tasks available.'));
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            final isDone = task['done'] == true;
            return ListTile(
              title: Text(
                task['title'] ?? '',
                style: TextStyle(
                  decoration: isDone ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Text(task['description'] ?? ''),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () => store.completeTask(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => store.removeTask(index),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
