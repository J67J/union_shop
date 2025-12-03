class Product {
  final String title;
  final String price;
  final String image;

  const Product({required this.title, required this.price, required this.image});
}

const List<Product> products = [
  Product(title: 'Grey hoodie', price: '£10.00', image: 'assets/images/product_1.png'),
  Product(title: 'T-shirt', price: '£15.00', image: 'assets/images/product_2.png'),
  Product(title: 'Crop top', price: '£20.00', image: 'assets/images/product_3.png'),
  Product(title: 'Grey joggers', price: '£25.00', image: 'assets/images/product_4.png'),
];
