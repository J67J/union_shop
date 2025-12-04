import 'package:flutter/material.dart';
import 'package:union_shop/models/cart.dart';
import 'package:union_shop/services/user_store.dart';
import 'package:union_shop/auth_page.dart';
import 'package:union_shop/models/orders.dart';

class BasketPage extends StatefulWidget {
  const BasketPage({super.key});

  @override
  State<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4d2963),
        title: const Text('Basket'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              Cart.instance.clear();
            },
            tooltip: 'Clear basket',
          ),
        ],
      ),
      body: ValueListenableBuilder<List<CartItem>>(
        valueListenable: Cart.instance.items,
        builder: (context, items, _) {
          if (items.isEmpty) {
            return const Center(child: Text('Your basket is empty'));
          }
          // show items with quantity controls and subtotal, then checkout
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final it = items[index];
                    final subtotal = (it.product.unitPrice * it.quantity);
                    return ListTile(
                      leading: SizedBox(
                        width: 56,
                        height: 56,
                        child: Image.asset(it.product.image, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported)),
                      ),
                      title: Text(it.product.title),
                      subtitle: Text('Size: ${it.size}'),
                      trailing: SizedBox(
                        width: 180,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => Cart.instance.updateQuantity(index, it.quantity - 1),
                            ),
                            Text('${it.quantity}', style: const TextStyle(fontSize: 16)),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () => Cart.instance.updateQuantity(index, it.quantity + 1),
                            ),
                            const SizedBox(width: 12),
                            Text('£${subtotal.toStringAsFixed(2)}'),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => Cart.instance.removeAt(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Total: £${items.fold<double>(0.0, (s, it) => s + it.product.unitPrice * it.quantity).toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4d2963)),
                      onPressed: () async {
                        final email = UserStore.instance.currentUser.value;
                        if (email == null) {
                          final messenger = ScaffoldMessenger.of(context);
                          messenger.showSnackBar(const SnackBar(content: Text('Please sign in to place an order')));
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthPage()));
                          return;
                        }

                        // Snapshot the current cart items at checkout time
                        final currentItems = List.of(Cart.instance.items.value);
                        if (currentItems.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Your basket is empty')));
                          return;
                        }

                        // Build order from live cart snapshot
                        final created = DateTime.now();
                        final id = created.millisecondsSinceEpoch.toString();
                        final orderItems = currentItems
                            .map((it) => OrderItem(title: it.product.title, size: it.size, quantity: it.quantity, unitPrice: it.product.unitPrice))
                            .toList();
                        final total = currentItems.fold<double>(0.0, (s, it) => s + it.product.unitPrice * it.quantity);
                        final order = Order(id: id, createdAt: created, items: orderItems, total: total);

                        await OrdersStore.addOrderFor(email, order);
                        Cart.instance.clear();

                        // show confirmation dialog
                        if (!mounted) return;
                        // ignore: use_build_context_synchronously
                        await showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Order placed'),
                            content: Text('Your order #$id has been placed. Total: £${total.toStringAsFixed(2)}'),
                            actions: [
                              TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('OK')),
                            ],
                          ),
                        );

                        if (!mounted) return;
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushNamed('/');
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text('Checkout', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
