import 'package:flutter/foundation.dart';
import 'package:union_shop/models/product.dart';

class CartItem {
  final Product product;
  final String size;
  final int quantity;

  CartItem({required this.product, required this.size, required this.quantity});
}

class Cart {
  Cart._privateConstructor();
  static final Cart instance = Cart._privateConstructor();

  /// Public list of items as a ValueNotifier so UI can listen for changes.
  final ValueNotifier<List<CartItem>> items = ValueNotifier<List<CartItem>>([]);

  void addItem(CartItem item) {
    items.value = List<CartItem>.from(items.value)..add(item);
  }

  void removeAt(int index) {
    final list = List<CartItem>.from(items.value);
    if (index >= 0 && index < list.length) {
      list.removeAt(index);
      items.value = list;
    }
  }

  void clear() {
    items.value = [];
  }
}
