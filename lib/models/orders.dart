import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class OrderItem {
  final String title;
  final String size;
  final int quantity;
  final double unitPrice;

  OrderItem({required this.title, required this.size, required this.quantity, required this.unitPrice});

  Map<String, dynamic> toMap() => {
        'title': title,
        'size': size,
        'quantity': quantity,
        'unitPrice': unitPrice,
      };

  static OrderItem fromMap(Map<String, dynamic> m) => OrderItem(
        title: m['title'] as String,
        size: m['size'] as String,
        quantity: m['quantity'] as int,
        unitPrice: (m['unitPrice'] as num).toDouble(),
      );
}

class Order {
  final String id;
  final DateTime createdAt;
  final List<OrderItem> items;
  final double total;

  Order({required this.id, required this.createdAt, required this.items, required this.total});

  Map<String, dynamic> toMap() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'items': items.map((i) => i.toMap()).toList(),
        'total': total,
      };

  static Order fromMap(Map<String, dynamic> m) => Order(
        id: m['id'] as String,
        createdAt: DateTime.parse(m['createdAt'] as String),
        items: (m['items'] as List<dynamic>).map((e) => OrderItem.fromMap(Map<String, dynamic>.from(e as Map))).toList(),
        total: (m['total'] as num).toDouble(),
      );
}

class OrdersStore {
  static const _kPrefix = 'union_shop_orders_';

  static Future<List<Order>> getOrdersFor(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_kPrefix${email.toLowerCase()}');
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.map((e) => Order.fromMap(Map<String, dynamic>.from(e as Map))).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> addOrderFor(String email, Order order) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_kPrefix${email.toLowerCase()}';
    final existing = await getOrdersFor(email);
    final newList = [order, ...existing];
    final encoded = jsonEncode(newList.map((o) => o.toMap()).toList());
    await prefs.setString(key, encoded);
  }
}
