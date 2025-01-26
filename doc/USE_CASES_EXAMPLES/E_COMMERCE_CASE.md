# E-Commerce Case Study with **upper_flutter_stores**

This document demonstrates how to use **upper_flutter_stores** to build a scalable and efficient state management solution for an e-commerce application. The focus is on performance, simplicity, and adherence to the "ease of use" philosophy.

---

## **Scenario**

You are building an e-commerce application with the following key features:

1. **Product Listing**:
   - Display a list of products fetched from an API.
   - Support filtering and sorting.

2. **Product Details**:
   - Display detailed information about a product.
   - Allow users to add items to the cart.

3. **Shopping Cart**:
   - View items added to the cart.
   - Update quantities or remove items.

4. **Order Management**:
   - Place orders.
   - View past orders.

---

## **Recommended Architecture**

For this use case, we’ll use the **Feature-First Architecture** with stores tailored for specific features. Each feature will have its own store, keeping logic encapsulated and scalable.

### **Folder Structure**

```
lib/
├── main.dart
├── features/
│   ├── product/
│   │   ├── screens/
│   │   │   ├── product_list_screen.dart
│   │   │   ├── product_details_screen.dart
│   │   ├── store/
│   │   │   ├── product_store.dart
│   ├── cart/
│   │   ├── screens/
│   │   │   ├── cart_screen.dart
│   │   ├── store/
│   │   │   ├── cart_store.dart
│   ├── order/
│   │   ├── screens/
│   │   │   ├── order_screen.dart
│   │   ├── store/
│   │   │   ├── order_store.dart
├── common/
│   ├── widgets/
│   ├── models/
│   │   ├── product_model.dart
│   │   ├── cart_item_model.dart
│   │   ├── order_model.dart
```

---

## **Implementation**

### **1. Product Store**

The `ProductStore` handles product data and supports filtering and sorting.

```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class ProductStore extends StoreInterface<Map<String, dynamic>> {
  ProductStore()
      : super(
          {
            'products': [],
            'filters': {},
            'sort': null,
          },
          enableDebugging: true,
        );

  List<dynamic> get products => state['products'];

  Future<void> fetchProducts() async {
    // Simulate API call
    final fetchedProducts = [
      {'id': 1, 'name': 'Product A', 'price': 100},
      {'id': 2, 'name': 'Product B', 'price': 200},
    ];
    set({'products': fetchedProducts});
  }

  void applyFilter(Map<String, dynamic> filter) {
    set({'filters': filter});
    // Implement filtering logic here
  }

  void applySort(String sortOption) {
    set({'sort': sortOption});
    // Implement sorting logic here
  }
}
```

### **2. Cart Store**

The `CartStore` manages cart items and supports adding, updating, and removing items.

```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class CartStore extends StoreInterface<Map<String, dynamic>> {
  CartStore()
      : super(
          {
            'cartItems': [],
          },
          enablePersistence: true,
          persistKey: 'cart_store',
          enableDebugging: true,
        ){
    initializePersistence();
  }

  List<dynamic> get cartItems => state['cartItems'];

  void addToCart(Map<String, dynamic> product) {
    final updatedCart = [...cartItems, product];
    set({'cartItems': updatedCart});
  }

  void updateQuantity(int productId, int quantity) {
    final updatedCart = cartItems.map((item) {
      if (item['id'] == productId) {
        return {...item, 'quantity': quantity};
      }
      return item;
    }).toList();
    set({'cartItems': updatedCart});
  }

  void removeFromCart(int productId) {
    final updatedCart = cartItems.where((item) => item['id'] != productId).toList();
    set({'cartItems': updatedCart});
  }
}
```

### **3. Order Store**

The `OrderStore` handles placing orders and viewing order history.

```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class OrderStore extends StoreInterface<Map<String, dynamic>> {
  OrderStore()
      : super(
          {
            'orders': [],
          },
          enablePersistence: true,
          persistKey: 'order_store',
          enableDebugging: true,
        ){
    initializePersistence();
  }

  List<dynamic> get orders => state['orders'];

  void placeOrder(List<dynamic> cartItems) {
    final newOrder = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'items': cartItems,
      'total': cartItems.fold(0, (sum, item) => sum + item['price'] * item['quantity']),
    };
    set({'orders': [...orders, newOrder]});
  }
}
```

---

## **Connecting Stores to the UI**

### **Product List Screen**

```dart
import 'package:flutter/material.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';
import '../store/product_store.dart';

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productStore = StoreProvider.of<ProductStore>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: Column(
        children: [
          Expanded(
            child: StoreConsumer<ProductStore>(
              builder: (context, store) {
                final products = store.products;
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ListTile(
                      title: Text(product['name']),
                      subtitle: Text('\$${product['price']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.add_shopping_cart),
                        onPressed: () {
                          final cartStore = StoreProvider.of<CartStore>(context);
                          cartStore.addToCart({...product, 'quantity': 1});
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => productStore.fetchProducts(),
        child: Icon(Icons.refresh),
      ),
    );
  }
}
```

### **Cart Screen**

```dart
import 'package:flutter/material.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';
import '../store/cart_store.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: StoreConsumer<CartStore>(
        builder: (context, store) {
          final cartItems = store.cartItems;
          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return ListTile(
                title: Text(item['name']),
                subtitle: Text('Quantity: ${item['quantity']}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => store.removeFromCart(item['id']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
```

---

## **Conclusion**

The **upper_flutter_stores** package provides a simple yet powerful approach to state management. By structuring your application with feature-specific stores and leveraging the package’s flexibility, you can build performant and maintainable solutions without overengineering.
