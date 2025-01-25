import 'package:flutter/material.dart';
import 'package:flutter_stores_example/todo_provider.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController _categoryController = TextEditingController();

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = TodoProvider.of(context).todoStore;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final newCategory = _categoryController.text.trim();
                if (newCategory.isNotEmpty) {
                  store.addCategory(newCategory);
                  _categoryController.clear(); // Clear the input after success
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Category "$newCategory" added!')),
                  );
                  Navigator.pop(context); // Navigate back
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Category name cannot be empty')),
                  );
                }
              },
              child: const Text('Add Category'),
            ),
          ],
        ),
      ),
    );
  }
}
