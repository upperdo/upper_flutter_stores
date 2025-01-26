import 'package:flutter/widgets.dart';
import 'package:upper_flutter_stores/src/independent/base_store.dart';
import 'package:upper_flutter_stores/src/store/store_provider.dart';

/// Abstract base so we can store different typed definitions in one list.
abstract class BaseStoreDefinition {
  /// Wraps the given child widget in a typed StoreProvider.
  Widget wrap(Widget child);
}

/// A concrete definition that holds a typed store
/// and wraps the child with a matching StoreProvider<T>.
class StoreDefinition<T extends BaseStore> extends BaseStoreDefinition {
  final T store;

  StoreDefinition(this.store);

  @override
  Widget wrap(Widget child) {
    return StoreProvider<T>(
      store: store,
      child: child,
    );
  }
}
