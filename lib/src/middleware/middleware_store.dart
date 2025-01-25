import 'package:upper_flutter_stores/src/independent/base_store.dart';

typedef Middleware<T> = void Function(T oldState, T newState);

class MiddlewareStore<T> extends BaseStore<T> {
  final List<Middleware<T>> _middlewares = [];
  final String? debugContext;

  MiddlewareStore(
    T initialState, {
    bool enableDebugging = false,
    this.debugContext,
  }) : super(initialState, enableDebugging: enableDebugging) {
    if (enableDebugging) {
      print(
          '${debugContext ?? "MiddlewareStore"}: Initialized with state $initialState');
    }
  }

  void addMiddleware(Middleware<T> middleware) {
    _middlewares.add(middleware);
    if (enableDebugging) {
      print('${debugContext ?? "MiddlewareStore"}: Middleware added.');
    }
  }

  void removeMiddleware(Middleware<T> middleware) {
    _middlewares.remove(middleware);
    if (enableDebugging) {
      print('${debugContext ?? "MiddlewareStore"}: Middleware removed.');
    }
  }

  @override
  void set(T newState) {
    if (enableDebugging) {
      print(
          '${debugContext ?? "MiddlewareStore"}: Setting new state $newState');
    }

    for (var middleware in _middlewares) {
      if (enableDebugging) {
        print(
            '${debugContext ?? "MiddlewareStore"}: Executing middleware with old state $state and new state $newState');
      }
      middleware(state, newState);
    }

    super.set(newState);

    if (enableDebugging) {
      print('${debugContext ?? "MiddlewareStore"}: State updated to $newState');
    }
  }
}
