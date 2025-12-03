class Product {
  final String title;
  final String price;
  final String image;

  const Product({required this.title, required this.price, required this.image});
}

const List<Product> products = [
  Product(title: 'Placeholder Product 1', price: '£10.00', image: 'assets/images/product_1.png'),
  Product(title: 'Placeholder Product 2', price: '£15.00', image: 'assets/images/product_2.png'),
  Product(title: 'Placeholder Product 3', price: '£20.00', image: 'assets/images/product_3.png'),
  Product(title: 'Placeholder Product 4', price: '£25.00', image: 'assets/images/product_4.png'),
];
