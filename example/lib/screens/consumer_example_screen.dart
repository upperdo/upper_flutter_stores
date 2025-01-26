import 'package:flutter/material.dart';
import 'package:flutter_stores_example/store/todo_store.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class ConsumerExampleScreen extends StatelessWidget {
  const ConsumerExampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StoreConsumer Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StoreConsumer<TodoStore>(
          builder: (context, store) {
            final tasks = store.tasks;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tasks:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                if (tasks.isEmpty)
                  const Text('No tasks available.')
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return ListTile(
                          title: Text(task['title'] ?? ''),
                          subtitle: Text(task['description'] ?? ''),
                          trailing: IconButton(
                            icon: Icon(
                              task['done'] == true
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: task['done'] == true
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            onPressed: () => store.completeTask(index),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
