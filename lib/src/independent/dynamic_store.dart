import 'base_store.dart';

class DynamicStore<K, V> extends BaseStore<Map<K, V>> {
  final String? debugContext;

  DynamicStore(
    Map<K, V> initialState, {
    bool enableDebugging = false,
    this.debugContext,
  }) : super(initialState, enableDebugging: enableDebugging) {
    if (enableDebugging) {
      print(
          'DynamicStore [$debugContext]: Initialized with state: $initialState');
    }
  }

  void updateKey(K key, V value) {
    final newState = {...state, key: value};
    set(newState);

    if (enableDebugging) {
      print(
          'DynamicStore [$debugContext]: Key "$key" updated with value: $value');
    }
  }

  void removeKey(K key) {
    if (state.containsKey(key)) {
      final newState = {...state}..remove(key);
      set(newState);

      if (enableDebugging) {
        print('DynamicStore [$debugContext]: Key "$key" removed.');
      }
    } else if (enableDebugging) {
      print(
          'DynamicStore [$debugContext]: Key "$key" does not exist. No action taken.');
    }
  }

  bool containsKey(K key) {
    final contains = state.containsKey(key);

    if (enableDebugging) {
      print('DynamicStore [$debugContext]: containsKey("$key") => $contains');
    }

    return contains;
  }

  V? getValue(K key) {
    final value = state[key];

    if (enableDebugging) {
      print('DynamicStore [$debugContext]: getValue("$key") => $value');
    }

    return value;
  }
}
