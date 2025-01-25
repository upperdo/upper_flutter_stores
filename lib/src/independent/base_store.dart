import 'package:flutter/foundation.dart';

/// A base store class for managing state and notifying listeners on state changes.
class BaseStore<T> extends ChangeNotifier implements ValueListenable<T> {
  T _state;
  bool enableDebugging;
  final String? debugContext; // Optional context for debugging

  final List<void Function(T)> _listeners = [];

  /// Initializes the store with an initial state.
  BaseStore(this._state, {this.enableDebugging = false, this.debugContext}) {
    if (enableDebugging) {
      print('BaseStore [$debugContext]: Initialized with state: $_state');
    }
  }

  /// The current state.
  @override
  T get value => _state;

  T get state => _state;

  /// Updates the state and notifies listeners.
  void set(T newState) {
    if (enableDebugging) {
      print('BaseStore [$debugContext]: State updated: $_state => $newState');
    }
    _state = newState;
    _notifyListeners();
    notifyListeners();
  }

  /// Adds a listener to be notified when the state changes.
  void subscribe(void Function(T) listener) {
    _listeners.add(listener);
    if (enableDebugging) {
      print(
          'BaseStore [$debugContext]: New listener added. Total: ${_listeners.length}');
    }
    listener(_state); // Trigger initial callback with current state.
  }

  /// Removes a listener.
  void unsubscribe(void Function(T) listener) {
    if (_listeners.remove(listener)) {
      if (enableDebugging) {
        print(
            'BaseStore [$debugContext]: Listener removed. Remaining: ${_listeners.length}');
      }
    } else if (enableDebugging) {
      print(
          'BaseStore [$debugContext]: Attempted to remove a non-existent listener.');
    }
  }

  /// Notifies all registered listeners of the current state.
  void _notifyListeners() {
    if (enableDebugging) {
      print(
          'BaseStore [$debugContext]: Notifying ${_listeners.length} listeners.');
    }
    for (var listener in _listeners) {
      listener(_state);
    }
  }
}
