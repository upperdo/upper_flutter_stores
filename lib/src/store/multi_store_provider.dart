import 'package:flutter/widgets.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class MultiStoreProvider extends StatelessWidget {
  /// A list of typed store definitions, each able to wrap a widget in its StoreProvider.
  final List<BaseStoreDefinition> definitions;

  /// The child widget that will ultimately be wrapped by all stores.
  final Widget child;

  const MultiStoreProvider({
    Key? key,
    required this.definitions,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget tree = child;
    // Wrap the child in each store's provider, in reverse order
    for (final def in definitions.reversed) {
      tree = def.wrap(tree);
    }
    return tree;
  }
}
