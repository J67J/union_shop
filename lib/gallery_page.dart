import 'package:flutter/material.dart';
import 'package:union_shop/widgets/footer.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  void openProduct(BuildContext context) {
    Navigator.pushNamed(context, '/product');
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    final items = const [
      {'title': 'Placeholder Product 1', 'price': '£10.00', 'image': 'assets/images/product_1.png'},
      {'title': 'Placeholder Product 2', 'price': '£15.00', 'image': 'assets/images/product_2.png'},
      {'title': 'Placeholder Product 3', 'price': '£20.00', 'image': 'assets/images/product_3.png'},
      {'title': 'Placeholder Product 4', 'price': '£25.00', 'image': 'assets/images/product_4.png'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Collections'),
        backgroundColor: const Color(0xFF4d2963),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top banner (site-wide sale)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: const Color(0xFF4d2963),
              child: const Text(
                'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isWide ? 4 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
                children: items.map((it) {
                  return GestureDetector(
                    onTap: () => openProduct(context),
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      elevation: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Image.asset(
                              it['image']!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(it['title']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                Text(it['price']!, style: const TextStyle(color: Colors.grey)),
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

            // Footer
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Footer(),
            ),
          ],
        ),
      ),
    );
  }
}
