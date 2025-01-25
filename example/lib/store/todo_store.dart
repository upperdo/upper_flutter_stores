import 'package:upper_flutter_stores/upper_flutter_stores.dart';

/// TodoStore for managing tasks in the TODO app
class TodoStore {
  final Store<Map<String, dynamic>> todoStore;

  TodoStore()
      : todoStore = Store<Map<String, dynamic>>(
          {
            'tasks': <Map<String, dynamic>>[],
            'categories': <String>['General'],
            'snapshots': [],
          },
          enableDebugging: true,
          enableUndoRedo: true,
          enablePersistence: true,
          enableSnapshots: true,
          enableAsync: true,
          enableComputed: false,
          persistKey: 'todo_app',
          fromJson: (json) {
            final tasks = (json['tasks'] as List<dynamic>?)
                    ?.map((e) => Map<String, dynamic>.from(e as Map))
                    .toList() ??
                [];
            final categories = (json['categories'] as List<dynamic>?)
                    ?.map((e) => e as String)
                    .toList() ??
                [];
            return {
              'tasks': tasks,
              'categories': categories,
              'snapshots': json['snapshots'] ?? [],
            };
          },
          toJson: (state) => state,
        ) {
    _initializePersistence();
  }

  /// Initialize persistence
  Future<void> _initializePersistence() async {
    try {
      await todoStore.initializePersistence();
      print('TodoStore: State restored from persistence: ${todoStore.state}');
    } catch (e) {
      print('TodoStore: Failed to initialize persistence - $e');
    }
  }

  /// Save the current state persistently
  Future<void> _persistState() async {
    try {
      await todoStore.persist();
      print('TodoStore: State persisted successfully.');
    } catch (e) {
      print('TodoStore: Failed to persist state - $e');
    }
  }

  /// Initialize middleware
  void setupMiddleware() {
    todoStore.addMiddleware((oldState, newState) {
      print('Middleware: State changed from $oldState to $newState');
    });
  }

  /// Retrieve all tasks
  List<Map<String, dynamic>> get tasks {
    return todoStore.state['tasks'] ?? [];
  }

  /// Retrieve all categories
  List<String> get categories {
    return List<String>.from(todoStore.state['categories'] ?? []);
  }

  /// Add a task
  Future<void> addTask(Map<String, dynamic> task) async {
    final updatedTasks = [...tasks, task];
    todoStore.set({
      ...todoStore.state,
      'tasks': updatedTasks,
    });
    await _persistState(); // Save persistently
  }

  /// Remove a task by index
  Future<void> removeTask(int index) async {
    final updatedTasks = List<Map<String, dynamic>>.from(tasks)
      ..removeAt(index);
    todoStore.set({
      ...todoStore.state,
      'tasks': updatedTasks,
    });
    await _persistState(); // Save persistently
  }

  /// Mark a task as completed
  Future<void> completeTask(int index) async {
    final updatedTasks = List<Map<String, dynamic>>.from(tasks);
    updatedTasks[index]['done'] = !(updatedTasks[index]['done'] ?? false);
    todoStore.set({
      ...todoStore.state,
      'tasks': updatedTasks,
    });
    await _persistState(); // Save persistently
  }

  /// Add a category
  Future<void> addCategory(String category) async {
    final updatedCategories = [...categories, category];
    todoStore.set({
      ...todoStore.state,
      'categories': updatedCategories,
    });
    await _persistState(); // Save persistently
  }

  /// Check if there are any tasks
  bool get hasTasks => tasks.isNotEmpty;

  /// Filter tasks by category
  List<Map<String, dynamic>> filterTasksByCategory(String category) {
    return tasks.where((task) => task['category'] == category).toList();
  }

  /// Search tasks by query
  List<Map<String, dynamic>> searchTasks(String query) {
    return tasks
        .where((task) =>
            (task['title'] ?? '').toLowerCase().contains(query.toLowerCase()) ||
            (task['description'] ?? '')
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();
  }

  /// Undo last change
  void undo() {
    if (todoStore.canUndo) {
      todoStore.undo();
    }
  }

  /// Redo last undone change
  void redo() {
    if (todoStore.canRedo) {
      todoStore.redo();
    }
  }

  /// Take a snapshot of the current state
  void takeSnapshot() {
    todoStore.takeSnapshot();
  }

  /// Replay a snapshot by index
  void replaySnapshot(int index) {
    todoStore.replaySnapshot(index);
  }
}
