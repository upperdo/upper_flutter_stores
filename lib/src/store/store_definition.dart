import 'package:flutter/widgets.dart';
import 'package:upper_flutter_stores/src/independent/base_store.dart';
import 'package:upper_flutter_stores/src/store/store_provider.dart';

abstract class BaseStoreDefinition {
  Widget wrap(Widget child);
}

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
