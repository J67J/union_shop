import 'package:flutter/material.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/product_page.dart';

class ProductSearchDelegate extends SearchDelegate<Product?> {
  final List<Product> items;

  ProductSearchDelegate(this.items);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = items
        .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final p = results[index];
        return ListTile(
          leading: Image.asset(p.image, width: 48, height: 48, fit: BoxFit.cover),
          title: Text(p.title),
          subtitle: Text(p.price),
          onTap: () {
            // Open product page with selected product
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProductPage(product: p)),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      // Don't show suggestions until the user starts typing.
      return const Center(
        child: Text('Start typing to search products'),
      );
    }

    final suggestions = items
        .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final p = suggestions[index];
        return ListTile(
          leading: Image.asset(p.image, width: 48, height: 48, fit: BoxFit.cover),
          title: Text(p.title),
          subtitle: Text(p.price),
          onTap: () {
            query = p.title;
            showResults(context);
          },
        );
      },
    );
  }
}
