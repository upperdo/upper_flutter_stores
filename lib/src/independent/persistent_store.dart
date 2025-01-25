import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'base_store.dart';

class PersistentStore<T> extends BaseStore<T> {
  final String _key;
  final T Function(Map<String, dynamic>) _fromJson;
  final Map<String, dynamic> Function(T) _toJson;
  String? debugContext;

  PersistentStore(
    T initialState, {
    required String persistKey,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(T) toJson,
    this.debugContext,
    bool enableDebugging = false,
  })  : _key = persistKey,
        _fromJson = fromJson,
        _toJson = toJson,
        super(initialState, enableDebugging: enableDebugging) {
    if (enableDebugging) {
      print('PersistentStore [$debugContext]: Initialized with key: $_key');
    }
  }

  /// Asynchronously load persisted state
  Future<void> initialize() async {
    if (enableDebugging) {
      print('PersistentStore [$debugContext]: Initializing...');
    }
    await _loadPersistedState();
    if (enableDebugging) {
      print('PersistentStore [$debugContext]: Initialization complete');
    }
  }

  /// Save the current state to SharedPreferences
  Future<void> persist() async {
    if (enableDebugging) {
      print('PersistentStore [$debugContext]: Saving state...');
    }
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_toJson(state));
    await prefs.setString(_key, jsonString);
    if (enableDebugging) {
      print('PersistentStore [$debugContext]: State persisted: $jsonString');
    }
  }

  /// Load the persisted state from SharedPreferences
  Future<void> _loadPersistedState() async {
    if (enableDebugging) {
      print('PersistentStore [$debugContext]: Retrieving state...');
    }
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (enableDebugging) {
      print('PersistentStore [$debugContext]: Retrieved raw JSON: $jsonString');
    }
    if (jsonString != null) {
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      final restoredState = _fromJson(jsonMap);
      super.set(restoredState); // Use `super.set` to avoid triggering observers
      if (enableDebugging) {
        print(
            'PersistentStore [$debugContext]: State restored: $restoredState');
      }
    }
  }
}
