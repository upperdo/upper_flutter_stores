import 'base_store.dart';

class UndoableStore<T> extends BaseStore<T> {
  final List<T> _undoStack = [];
  final List<T> _redoStack = [];
  final String? debugContext;

  UndoableStore(
    T initialState, {
    this.debugContext,
    bool enableDebugging = false,
  }) : super(initialState, enableDebugging: enableDebugging) {
    if (enableDebugging) {
      print(
          'UndoableStore [$debugContext]: Initialized with state: $initialState');
    }
  }

  @override
  void set(T newState) {
    _undoStack.add(state);
    _redoStack.clear();
    if (enableDebugging) {
      print(
          'UndoableStore [$debugContext]: State updated: $state => $newState');
      print('UndoableStore [$debugContext]: Undo stack: $_undoStack');
      print('UndoableStore [$debugContext]: Redo stack cleared.');
    }
    super.set(newState);
  }

  void undo() {
    if (_undoStack.isNotEmpty) {
      _redoStack.add(state);
      final previousState = _undoStack.removeLast();
      if (enableDebugging) {
        print('UndoableStore [$debugContext]: Undo performed.');
        print(
            'UndoableStore [$debugContext]: Current state: $state => $previousState');
        print('UndoableStore [$debugContext]: Redo stack: $_redoStack');
        print('UndoableStore [$debugContext]: Undo stack: $_undoStack');
      }
      super.set(previousState);
    } else {
      if (enableDebugging) {
        print(
            'UndoableStore [$debugContext]: Undo not possible (stack empty).');
      }
    }
  }

  void redo() {
    if (_redoStack.isNotEmpty) {
      _undoStack.add(state);
      final nextState = _redoStack.removeLast();
      if (enableDebugging) {
        print('UndoableStore [$debugContext]: Redo performed.');
        print(
            'UndoableStore [$debugContext]: Current state: $state => $nextState');
        print('UndoableStore [$debugContext]: Undo stack: $_undoStack');
        print('UndoableStore [$debugContext]: Redo stack: $_redoStack');
      }
      super.set(nextState);
    } else {
      if (enableDebugging) {
        print(
            'UndoableStore [$debugContext]: Redo not possible (stack empty).');
      }
    }
  }

  bool get canUndo {
    if (enableDebugging) {
      print(
          'UndoableStore [$debugContext]: Can undo: ${_undoStack.isNotEmpty}');
    }
    return _undoStack.isNotEmpty;
  }

  bool get canRedo {
    if (enableDebugging) {
      print(
          'UndoableStore [$debugContext]: Can redo: ${_redoStack.isNotEmpty}');
    }
    return _redoStack.isNotEmpty;
  }
}
