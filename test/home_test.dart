import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';

void main() {
  group('Home Page Tests', () {
    testWidgets('should display home page with basic elements', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Check that basic UI elements are present
      expect(find.text('WELCOME TO THE UNION WEBSITE'), findsOneWidget);
      expect(find.text('BROWSE PRODUCTS'), findsOneWidget);
    });

    testWidgets('should display product cards', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Check that product cards are displayed (titles come from products list)
      expect(find.text('Grey hoodie'), findsOneWidget);
      expect(find.text('T-shirt'), findsOneWidget);
      expect(find.text('Crop top'), findsOneWidget);
      expect(find.text('Grey joggers'), findsOneWidget);
    });

    testWidgets('should display header icons', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Check that header icons are present (may appear multiple times)
      expect(find.byIcon(Icons.search), findsWidgets);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsWidgets);
      expect(find.byIcon(Icons.menu), findsWidgets);
    });

    testWidgets('should display footer', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Check that footer is present (opening hours section)
      expect(find.text('Opening hours'), findsOneWidget);
    });
  });
}
