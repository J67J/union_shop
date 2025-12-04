import 'package:flutter/material.dart';
import 'package:union_shop/widgets/footer.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/product_page.dart';

class SalePage extends StatelessWidget {
  const SalePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;
    return Scaffold(
      appBar: AppBar(title: const Text('Sale items'), backgroundColor: const Color(0xFF4d2963)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: const Color(0xFF4d2963),
              child: const Text(
                'SALE — discounted essentials',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isWide ? 4 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
                children: products.map((p) {
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProductPage(product: p))),
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      elevation: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Image.asset(
                              p.image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (c, e, s) => Container(
                                color: Colors.grey[200],
                                child: const Center(child: Icon(Icons.image_not_supported)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                Text(p.price, style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 16), child: Footer()),
          ],
        ),
      ),
    );
  }
}
