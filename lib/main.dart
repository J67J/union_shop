import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:union_shop/product_page.dart';
import 'package:union_shop/about_page.dart';
import 'package:union_shop/gallery_page.dart';
import 'package:union_shop/search/product_search.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/widgets/footer.dart';
import 'package:union_shop/auth_page.dart';
import 'package:union_shop/account_page.dart';
import 'package:union_shop/services/user_store.dart';
import 'package:union_shop/models/cart.dart';
import 'package:union_shop/basket_page.dart';
import 'package:union_shop/sale_page.dart';
import 'package:union_shop/print_shack_page.dart';

// Widgets and cart already imported above

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Cart.instance.load();
  runApp(const UnionShopApp());
}

class UnionShopApp extends StatelessWidget {
  const UnionShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Union Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4d2963)),
      ),
      home: const HomeScreen(),
      initialRoute: '/',
      routes: {
        '/product': (context) => const ProductPage(),
        '/about': (context) => const AboutUsPage(),
        '/gallery': (context) => const GalleryPage(),
        '/printshack': (context) => const PrintShackPage(),
        '/sale': (context) => const SalePage(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  final List<String> _heroImages = [
    'assets/images/Product_6.png',
    'assets/images/Product_7.png',
    'assets/images/Product_8.png',
    'assets/images/Product_9.png',
  ];

  // Using local asset images only for the hero slideshow.

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (t) {
      if (!mounted) return;
      _currentPage = (_currentPage + 1) % _heroImages.length;
      _pageController.animateToPage(_currentPage, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    });

    // Runtime check: attempt to load each asset and log result so we can
    // diagnose missing/bundling issues in the console.
    for (final path in _heroImages) {
      rootBundle.load(path).then((_) {
        debugPrint('Asset available at runtime: $path');
      }).catchError((e) {
        debugPrint('Asset NOT available at runtime: $path — $e');
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void navigateToProduct(BuildContext context) {
    Navigator.pushNamed(context, '/product');
  }

  void placeholderCallbackForButtons() {
    // placeholder for future handlers
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF4d2963)),
                child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              ListTile(
                leading: const Icon(Icons.collections_outlined),
                title: const Text('Collections'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/gallery');
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About Us'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/about');
                },
              ),
              ListTile(
                leading: const Icon(Icons.local_offer_outlined),
                title: const Text('Sale!'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/gallery');
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _homeBody(context),
          ],
        ),
      ),
    );
  }

  Widget _homeBody(BuildContext context) {
    return Column(
      children: [
            // Header
            Container(
              height: 100,
              color: Colors.white,
              child: Column(
                children: [
                  // Top banner
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
                  // Main header
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => navigateToHome(context),
                            child: Image.network(
                              'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
                              height: 18,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  width: 18,
                                  height: 18,
                                  child: const Center(
                                    child: Icon(Icons.image_not_supported, color: Colors.grey),
                                  ),
                                );
                              },
                            ),
                          ),
                          const Spacer(),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 600),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.search, size: 18, color: Colors.grey),
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                  onPressed: () {
                                    showSearch(context: context, delegate: ProductSearchDelegate(products));
                                  },
                                ),
                                // Keep search and basket visible; other actions moved to drawer or popup on wide screens
                                IconButton(
                                  icon: const Icon(Icons.person_outline, size: 18, color: Colors.grey),
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                  onPressed: () {
                                    final email = UserStore.instance.currentUser.value;
                                    if (email == null) {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthPage()));
                                    } else {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AccountPage()));
                                    }
                                  },
                                ),
                                ValueListenableBuilder<List<CartItem>>(
                                  valueListenable: Cart.instance.items,
                                  builder: (context, items, _) {
                                    final count = items.fold<int>(0, (s, it) => s + it.quantity);
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.shopping_bag_outlined, size: 18, color: Colors.grey),
                                            padding: const EdgeInsets.all(8),
                                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                            onPressed: () {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BasketPage()));
                                            },
                                          ),
                                          if (count > 0) ...[
                                            const SizedBox(width: 4),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                                              child: Text(
                                                count > 99 ? '99+' : '$count',
                                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 8),
                                // Small static menu button next to the bag icon that opens a dropdown
                                PopupMenuButton<int>(
                                  icon: const Icon(Icons.menu, size: 18, color: Colors.grey),
                                  // show the menu below the icon (small vertical offset)
                                  offset: const Offset(0, 36),
                                  itemBuilder: (context) => const [
                                    PopupMenuItem(value: 1, child: Text('Collections')),
                                    PopupMenuItem(value: 2, child: Text('About Us')),
                                    PopupMenuItem(value: 3, child: Text('Sale!')),
                                    PopupMenuItem(value: 4, child: Text('The Print Shack')),
                                  ],
                                  onSelected: (val) {
                                    switch (val) {
                                      case 1:
                                        Navigator.pushNamed(context, '/gallery');
                                        break;
                                      case 2:
                                        Navigator.pushNamed(context, '/about');
                                        break;
                                      case 3:
                                        Navigator.pushNamed(context, '/sale');
                                        break;
                                      case 4:
                                        Navigator.pushNamed(context, '/printshack');
                                        break;
                                    }
                                  },
                                ),
                                // removed extra menu icon - drawer is opened via the person/menu button
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Hero Section (slideshow)
            SizedBox(
              height: 400,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _heroImages.length,
                      itemBuilder: (context, index) {
                          final img = _heroImages[index];
                          // For web dev server the asset may be served at '/assets/images/..'
                          final webUrl = '/${img}';
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                webUrl,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return Container(color: Colors.grey[300]);
                                },
                                errorBuilder: (c, e, s) {
                                  debugPrint('Failed to load network asset URL: $webUrl — error: $e');
                                  return Container(
                                    color: Colors.grey[300],
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.broken_image, size: 48, color: Colors.black54),
                                          const SizedBox(height: 8),
                                          Text(webUrl, style: const TextStyle(color: Colors.black54)),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Container(color: Color.fromRGBO(0, 0, 0, 0.45)),
                            ],
                          );
                        },
                      onPageChanged: (i) => setState(() => _currentPage = i),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    right: 24,
                    top: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('welcome to The Union website', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2)),
                        const SizedBox(height: 16),
                        const Text(
                          "This is placeholder text for the hero section.",
                          style: TextStyle(fontSize: 20, color: Colors.white, height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, '/gallery'),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4d2963), foregroundColor: Colors.white, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                          child: const Text('BROWSE PRODUCTS', style: TextStyle(fontSize: 14, letterSpacing: 1)),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_heroImages.length, (i) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentPage == i ? 12 : 8,
                              height: 8,
                              decoration: BoxDecoration(color: _currentPage == i ? Colors.white : Colors.white54, borderRadius: BorderRadius.circular(4)),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Products Section
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    const Text('PRODUCTS SECTION', style: TextStyle(fontSize: 20, color: Colors.black, letterSpacing: 1)),
                    const SizedBox(height: 48),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 48,
                      children: products
                          .map((p) => ProductCard(title: p.title, price: p.price, imageUrl: p.image))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            const Padding(padding: EdgeInsets.only(top: 16), child: Footer()),
          ],
        );
  }
}

class ProductCard extends StatelessWidget {
  final String title;
  final String price;
  final String imageUrl;

  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ProductPage(product: Product(title: title, price: price, image: imageUrl))));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: imageUrl.startsWith('assets/')
                ? Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported, color: Colors.grey),
                        ),
                      );
                    },
                  )
                : Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported, color: Colors.grey),
                        ),
                      );
                    },
                  ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.black),
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              Text(
                price,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

