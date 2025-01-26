import 'package:upper_flutter_stores/upper_flutter_stores.dart';

/// TodoStore for managing tasks in the TODO app
class TodoStore extends StoreInterface<Map<String, dynamic>> {
  bool isInitialized = false;

  TodoStore()
      : super(
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
    initializePersistence();
  }

  @override
  Future<void> initializePersistence() async {
    await super.initializePersistence();
    isInitialized = true;
    notifyListeners();
  }

  /// Retrieve all tasks
  List<Map<String, dynamic>> get tasks {
    final data = List<Map<String, dynamic>>.from(state['tasks'] ?? []);
    print('Tasks retrieved: $data');
    return data;
  }

  List<String> get categories {
    final data = List<String>.from(state['categories'] ?? []);
    print('Categories retrieved: $data');
    return data;
  }

  /// Add a task
  Future<void> addTask(Map<String, dynamic> task) async {
    final updatedTasks = [...tasks, task];
    set({
      ...state,
      'tasks': updatedTasks,
    });
    await persistState();
  }

  /// Remove a task by index
  Future<void> removeTask(int index) async {
    print('Removing task at index: $index');
    final updatedTasks = List<Map<String, dynamic>>.from(tasks)
      ..removeAt(index);
    print('Updated tasks: $updatedTasks');
    set({
      ...state,
      'tasks': updatedTasks,
    });
    print('State after removing task: ${state['tasks']}');
    await persistState();
    print('Task removed and state persisted.');
  }

  /// Mark a task as completed
  Future<void> completeTask(int index) async {
    final updatedTasks = List<Map<String, dynamic>>.from(tasks);
    updatedTasks[index]['done'] = !(updatedTasks[index]['done'] ?? false);
    set({
      ...state,
      'tasks': updatedTasks,
    });
    await persistState();
  }

  /// Add a category
  Future<void> addCategory(String category) async {
    final updatedCategories = [...categories, category];
    set({
      ...state,
      'categories': updatedCategories,
    });
    await persistState(); // Save persistently
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
}
