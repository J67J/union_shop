import 'package:flutter/material.dart';
import 'package:union_shop/models/cart.dart';

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

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final it = items[index];
              return ListTile(
                leading: SizedBox(
                  width: 56,
                  height: 56,
                  child: Image.asset(it.product.image, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported)),
                ),
                title: Text(it.product.title),
                subtitle: Text('Size: ${it.size}  •  Quantity: ${it.quantity}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => Cart.instance.removeAt(index),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
