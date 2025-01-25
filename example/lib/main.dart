import 'package:flutter/material.dart';
import 'package:flutter_stores_example/screens/main_screen.dart';
import 'package:flutter_stores_example/store/todo_store.dart';
import 'package:flutter_stores_example/todo_provider.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todoStore = TodoStore();

    return TodoProvider(
        todoStore: todoStore,
        child: StoreLifecycleManager(
          child: MaterialApp(
            title: 'Flutter Stores TODO Example',
            theme: ThemeData(primarySwatch: Colors.blue),
            home: MainScreen(),
          ),
        ));
  }
}
