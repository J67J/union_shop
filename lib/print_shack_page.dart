import 'package:flutter/material.dart';
import 'package:union_shop/models/cart.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/basket_page.dart';

class PrintShackPage extends StatefulWidget {
  const PrintShackPage({super.key});

  @override
  State<PrintShackPage> createState() => _PrintShackPageState();
}

class _PrintShackPageState extends State<PrintShackPage> {
  final _formKey = GlobalKey<FormState>();

  int _selectedIndex = 0;
  
  String _customText = '';
  String _size = 'M';
  int _quantity = 1;

  List<String> get _sizes => ['XS', 'S', 'M', 'L', 'XL'];

  double get _unitPrice => products[_selectedIndex].unitPrice;
  double get _total => _unitPrice * _quantity;

  @override
  Widget build(BuildContext context) {
    final baseProduct = products[_selectedIndex];
    final isClothing = !baseProduct.title.toLowerCase().contains('mug');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4d2963),
        title: const Text('The Print Shack'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Order a personalised item', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                // Preview of selected product
                Center(
                  child: SizedBox(
                    height: 180,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          baseProduct.image,
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) => Container(
                            width: 160,
                            height: 160,
                            color: Colors.grey[200],
                            child: const Center(child: Icon(Icons.image_not_supported)),
                          ),
                        ),
                        if (_customText.trim().isNotEmpty)
                          Positioned(
                            bottom: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              color: Colors.black54,
                              child: Text(_customText.trim(), style: const TextStyle(color: Colors.white)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),


                DropdownButtonFormField<int>(
                  initialValue: _selectedIndex,
                  decoration: const InputDecoration(labelText: 'Product'),
                  items: products
                      .asMap()
                      .entries
                      .map((e) => DropdownMenuItem(value: e.key, child: Text('${e.value.title} — ${e.value.price}')))
                      .toList(),
                  onChanged: (v) => setState(() {
                    _selectedIndex = v ?? _selectedIndex;
                    final newIsClothing = !products[_selectedIndex].title.toLowerCase().contains('mug');
                    if (!newIsClothing) _size = 'One size';
                  }),
                ),

                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Custom text (what to print)'),
                  maxLength: 60,
                  onChanged: (v) => setState(() => _customText = v),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter text to print' : null,
                ),

                const SizedBox(height: 12),
                if (isClothing) ...[
                  DropdownButtonFormField<String>(
                    initialValue: _size,
                    decoration: const InputDecoration(labelText: 'Size'),
                    items: _sizes.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (v) => setState(() => _size = v ?? _size),
                  ),
                  const SizedBox(height: 12),
                ],

                Row(
                  children: [
                    const Text('Quantity', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => setState(() {
                        if (_quantity > 1) _quantity--;
                      }),
                    ),
                    Text('$_quantity', style: const TextStyle(fontSize: 16)),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => setState(() {
                        if (_quantity < 99) _quantity++;
                      }),
                    ),
                    const Spacer(),
                    Text('Unit: £${_unitPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),

                const SizedBox(height: 12),
                Text('Total: £${_total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4d2963)),
                    onPressed: () {
                      if (!(_formKey.currentState?.validate() ?? true)) return;

                      // Build a product representing this personalised item (preserve collection price/image)
                      final title = 'Personalised ${baseProduct.title}: "${_customText.trim()}"';
                      final prod = Product(title: title, price: baseProduct.price, image: baseProduct.image);
                      final sizeVal = isClothing ? _size : 'One size';
                      final item = CartItem(product: prod, size: sizeVal, quantity: _quantity);

                      Cart.instance.addItem(item);

                      final messenger = ScaffoldMessenger.of(context);
                      messenger.hideCurrentSnackBar();
                      messenger.showSnackBar(SnackBar(
                        content: const Text('Personalised item added to basket'),
                        duration: const Duration(seconds: 4),
                        action: SnackBarAction(label: 'View Basket', onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BasketPage()))),
                      ));
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      child: Text('Add to Basket', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

