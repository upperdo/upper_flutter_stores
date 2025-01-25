import 'base_store.dart';

class AsyncState<T> {
  final T? data;
  final Object? error;
  final StackTrace? stackTrace;
  final bool isLoading;

  const AsyncState._({
    this.data,
    this.error,
    this.stackTrace,
    this.isLoading = false,
  });

  factory AsyncState.idle() => const AsyncState._();

  factory AsyncState.loading() => const AsyncState._(isLoading: true);

  factory AsyncState.success(T data) => AsyncState._(data: data);

  factory AsyncState.error(Object error, StackTrace stackTrace) =>
      AsyncState._(error: error, stackTrace: stackTrace);

  @override
  String toString() {
    if (isLoading) return 'Loading..';
    if (error != null) return 'Error: $error';
    if (data != null) return 'Success: $data';
    return 'Idle';
  }
}

class AsyncStore<T> extends BaseStore<AsyncState<T>> {
  final String? debugContext;

  AsyncStore({bool enableDebugging = false, this.debugContext})
      : super(AsyncState.idle(), enableDebugging: enableDebugging);

  Future<void> run(Future<T> Function() task) async {
    if (enableDebugging) {
      print('AsyncStore [$debugContext]: Starting async task: $task');
    }

    set(AsyncState.loading());
    try {
      final result = await task();
      if (enableDebugging) {
        print(
            'AsyncStore [$debugContext]: Task completed successfully with result: $result');
      }
      set(AsyncState.success(result));
    } catch (e, stack) {
      if (enableDebugging) {
        print('AsyncStore [$debugContext]: Task failed with error: $e');
        print('AsyncStore [$debugContext]: Stack trace: $stack');
      }
      set(AsyncState.error(e, stack));
    } finally {
      if (enableDebugging) {
        print('AsyncStore [$debugContext]: Task execution finished.');
      }
    }
  }
}
