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

    final items = [
      {'title': 'The Print Shack', 'subtitle': 'Order personalised items', 'image': 'assets/images/product_1.png', 'route': '/printshack'},
      {'title': 'Sale items', 'subtitle': 'Discounted essentials', 'image': 'assets/images/product_2.png', 'route': '/sale'},
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
                crossAxisCount: isWide ? 2 : 1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 3,
                children: items.map((it) {
                  return GestureDetector(
                    onTap: () {
                      final route = it['route'];
                      if (route is String) Navigator.pushNamed(context, route);
                    },
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      elevation: 2,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 140,
                            child: Image.asset(
                              it['image']!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (c, e, s) => Container(
                                color: Colors.grey[200],
                                child: const Center(child: Icon(Icons.image_not_supported)),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(it['title']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 6),
                                  Text(it['subtitle'] ?? '', style: const TextStyle(color: Colors.grey)),
                                ],
                              ),
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
