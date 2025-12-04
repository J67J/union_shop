import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:union_shop/models/cart.dart';
import 'package:union_shop/models/product.dart';

void main() {
  group('Cart model tests', () {
    setUp(() async {
      // Ensure SharedPreferences uses an in-memory store for tests
      SharedPreferences.setMockInitialValues({});
      // Clear cart
      Cart.instance.items.value = [];
    });

    test('adding and merging items updates quantities and total', () async {
      final p1 = products[0]; // Grey hoodie
      final item1 = CartItem(product: p1, size: 'M', quantity: 1);
      Cart.instance.addItem(item1);

      // Add same product+size again
      Cart.instance.addItem(CartItem(product: p1, size: 'M', quantity: 2));

      expect(Cart.instance.items.value.length, 1);
      expect(Cart.instance.items.value.first.quantity, 3);

      final expectedTotal = p1.unitPrice * 3;
      expect(Cart.instance.total, expectedTotal);
    });

    test('updateQuantity removes when set to zero', () async {
      final p2 = products[1];
      Cart.instance.items.value = [CartItem(product: p2, size: 'L', quantity: 2)];
      Cart.instance.updateQuantity(0, 0);
      expect(Cart.instance.items.value.isEmpty, true);
    });
  });
}
