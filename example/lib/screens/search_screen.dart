import 'package:flutter/material.dart';
import 'package:flutter_stores_example/todo_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    final store = TodoProvider.of(context).todoStore;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Tasks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Query',
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                final results = store.searchTasks(query);
                setState(() {
                  _searchResults = results;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _searchResults.isEmpty
                  ? const Center(child: Text('No results found.'))
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final task = _searchResults[index];
                        return ListTile(
                          title: Text(task['title'] ?? ''),
                          subtitle: Text(task['description'] ?? ''),
                          trailing: task['done'] == true
                              ? const Icon(Icons.check, color: Colors.green)
                              : null,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
