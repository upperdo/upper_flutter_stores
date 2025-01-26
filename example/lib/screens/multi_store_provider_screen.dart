import 'package:flutter/material.dart';
import 'package:flutter_stores_example/store/sample_store.dart';
import 'package:flutter_stores_example/store/todo_store.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class MultiStoreProviderScreen extends StatelessWidget {
  const MultiStoreProviderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiStoreProvider(
      definitions: [
        StoreDefinition(TodoStore()),
        StoreDefinition(SampleStore()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('MultiStoreProvider Example'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Todo Store Tasks:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: StoreConsumer<TodoStore>(
                  builder: (context, todoStore) {
                    final tasks = todoStore.tasks;
                    return tasks.isEmpty
                        ? const Text('No tasks available.')
                        : ListView.builder(
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
                                  onPressed: () =>
                                      todoStore.completeTask(index),
                                ),
                              );
                            },
                          );
                  },
                ),
              ),
              const Divider(),
              const Text(
                'Another Store Data:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: StoreConsumer<SampleStore>(
                  builder: (context, sampleStore) {
                    final sampleData = sampleStore.sampleData;
                    return Text(
                      'Sample Data: $sampleData',
                      style: const TextStyle(fontSize: 16),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
