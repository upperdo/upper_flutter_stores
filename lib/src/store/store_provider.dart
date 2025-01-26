import 'package:flutter/widgets.dart';
import 'package:upper_flutter_stores/src/independent/base_store.dart';

class StoreProvider<T extends BaseStore> extends InheritedWidget {
  final T store;

  const StoreProvider({
    Key? key,
    required Widget child,
    required this.store,
  }) : super(key: key, child: child);

  static T of<T extends BaseStore>(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<StoreProvider<T>>();
    assert(provider != null, 'No StoreProvider found for type $T');
    return provider!.store;
  }

  @override
  bool updateShouldNotify(covariant StoreProvider<T> oldWidget) {
    return oldWidget.store != store;
  }
}
