import 'package:flutter/material.dart';
import 'package:union_shop/search/product_search.dart';
import 'package:union_shop/models/product.dart';

class Footer extends StatelessWidget {
  final VoidCallback? onSearch;

  const Footer({super.key, this.onSearch});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    Widget sectionTitle(String t) => Text(
          t,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        );

    Widget linkTile(IconData icon, String text, {VoidCallback? onTap}) => ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, size: 20, color: Colors.grey[700]),
          title: Text(text, style: const TextStyle(color: Colors.black87)),
          onTap: onTap,
        );

    const openingHours = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Opening hours', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        SizedBox(height: 6),
        Text('Mon - Fri: 09:00 - 17:00'),
        Text('Sat: 10:00 - 16:00'),
        Text('Sun: Closed'),
      ],
    );

    final helpInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle('Help & Information'),
        const SizedBox(height: 6),
        linkTile(Icons.info_outline, 'About Us', onTap: () => Navigator.pushNamed(context, '/about')),
      ],
    );

    final policies = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        linkTile(Icons.policy_outlined, 'Terms & Conditions of Sale', onTap: () {}),
      ],
    );

    final searchColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle('Search'),
        const SizedBox(height: 6),
        ElevatedButton.icon(
          onPressed: onSearch ?? () {
            showSearch(context: context, delegate: ProductSearchDelegate(products));
          },
          icon: const Icon(Icons.search),
          label: const Text('Search products'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4d2963),
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );

    return Container(
      width: double.infinity,
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      child: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 220, child: openingHours),
                SizedBox(width: 260, child: helpInfo),
                SizedBox(width: 240, child: policies),
                SizedBox(width: 220, child: searchColumn),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                openingHours,
                const SizedBox(height: 16),
                helpInfo,
                const SizedBox(height: 16),
                policies,
                const SizedBox(height: 16),
                searchColumn,
              ],
            ),
    );
  }
}
