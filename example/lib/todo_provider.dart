import 'package:flutter/cupertino.dart';
import 'package:flutter_stores_example/store/todo_store.dart';

class TodoProvider extends InheritedWidget {
  final TodoStore todoStore;

  const TodoProvider({
    Key? key,
    required Widget child,
    required this.todoStore,
  }) : super(key: key, child: child);

  static TodoProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TodoProvider>()!;
  }

  @override
  bool updateShouldNotify(TodoProvider oldWidget) =>
      todoStore != oldWidget.todoStore;
}
