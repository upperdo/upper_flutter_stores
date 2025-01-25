import 'package:flutter/widgets.dart';

/// A lifecycle manager that helps manage automatic cleanup of resources,
/// such as subscriptions, tied to a widget's lifecycle.
class StoreLifecycleManager extends StatefulWidget {
  final Widget child;

  /// Enables debugging to log lifecycle events and dispose callbacks.
  final bool debuggable;

  /// Creates a [StoreLifecycleManager] wrapping the given [child].
  const StoreLifecycleManager({
    Key? key,
    required this.child,
    this.debuggable = false, // Default is false for production usage
  }) : super(key: key);

  /// Registers a dispose callback to be executed when the [StoreLifecycleManager] is disposed.
  static void register(BuildContext context, VoidCallback onDispose) {
    final StoreLifecycleManagerState? state =
        context.findAncestorStateOfType<StoreLifecycleManagerState>();
    if (state != null) {
      state.registerDisposeCallback(onDispose);
    } else {
      throw FlutterError(
          'StoreLifecycleManager.register was called outside of a StoreLifecycleManager context.');
    }
  }

  @override
  StoreLifecycleManagerState createState() => StoreLifecycleManagerState();
}

class StoreLifecycleManagerState extends State<StoreLifecycleManager> {
  final List<VoidCallback> _disposeCallbacks = [];

  /// Registers a callback to be executed when the widget is disposed.
  void registerDisposeCallback(VoidCallback callback) {
    if (widget.debuggable) {
      debugPrint('StoreLifecycleManager: Registered a dispose callback.');
    }
    _disposeCallbacks.add(callback);
  }

  @override
  void dispose() {
    if (widget.debuggable) {
      debugPrint(
          'StoreLifecycleManager: Disposing with ${_disposeCallbacks.length} callbacks.');
    }

    for (final callback in _disposeCallbacks) {
      try {
        callback();
        if (widget.debuggable) {
          debugPrint('StoreLifecycleManager: Executed a dispose callback.');
        }
      } catch (e, stackTrace) {
        debugPrint(
            'StoreLifecycleManager: Error executing dispose callback: $e\n$stackTrace');
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.debuggable) {
      debugPrint('StoreLifecycleManager: Build called.');
    }
    return widget.child;
  }
}
