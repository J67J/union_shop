import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:union_shop/models/product.dart';

class CartItem {
  final Product product;
  final String size;
  final int quantity;

  CartItem({required this.product, required this.size, required this.quantity});

  Map<String, dynamic> toMap(int productIndex) => {
        'product': productIndex,
        'size': size,
        'quantity': quantity,
      };

  static CartItem fromMap(Map<String, dynamic> m) {
    final idx = m['product'] as int;
    final prod = products[idx];
    return CartItem(product: prod, size: m['size'] as String, quantity: m['quantity'] as int);
  }
}

class Cart {
  Cart._privateConstructor();
  static final Cart instance = Cart._privateConstructor();

  static const _kKey = 'union_shop_cart_v1';

  /// Public list of items as a ValueNotifier so UI can listen for changes.
  final ValueNotifier<List<CartItem>> items = ValueNotifier<List<CartItem>>([]);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      final loaded = decoded.map((e) => CartItem.fromMap(Map<String, dynamic>.from(e as Map))).toList();
      items.value = loaded;
    } catch (_) {
      // ignore parse errors
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    // we store product index instead of duplicating product data
    final encoded = jsonEncode(items.value.map((it) => it.toMap(products.indexWhere((p) => p.title == it.product.title))).toList());
    await prefs.setString(_kKey, encoded);
  }

  void addItem(CartItem item) {
    // Merge if same product + size
    final list = List<CartItem>.from(items.value);
    final matchIndex = list.indexWhere((it) => it.product.title == item.product.title && it.size == item.size);
    if (matchIndex >= 0) {
      final existing = list[matchIndex];
      list[matchIndex] = CartItem(product: existing.product, size: existing.size, quantity: existing.quantity + item.quantity);
    } else {
      list.add(item);
    }
    items.value = list;
    _save();
  }

  void updateQuantity(int index, int quantity) {
    final list = List<CartItem>.from(items.value);
    if (index >= 0 && index < list.length) {
      final it = list[index];
      if (quantity <= 0) {
        list.removeAt(index);
      } else {
        list[index] = CartItem(product: it.product, size: it.size, quantity: quantity);
      }
      items.value = list;
      _save();
    }
  }

  void removeAt(int index) {
    final list = List<CartItem>.from(items.value);
    if (index >= 0 && index < list.length) {
      list.removeAt(index);
      items.value = list;
      _save();
    }
  }

  void clear() {
    items.value = [];
    _save();
  }

  double get total {
    return items.value.fold(0.0, (sum, it) => sum + it.product.unitPrice * it.quantity);
  }
}
