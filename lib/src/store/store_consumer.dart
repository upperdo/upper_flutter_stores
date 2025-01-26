import 'package:flutter/material.dart';
import 'package:upper_flutter_stores/src/independent/base_store.dart';
import 'package:upper_flutter_stores/src/store/store_provider.dart';

class StoreConsumer<T extends BaseStore> extends StatelessWidget {
  final Widget Function(BuildContext context, T store) builder;

  const StoreConsumer({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<T>(context);
    return builder(context, store);
  }
}
