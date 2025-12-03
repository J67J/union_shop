import 'package:flutter/material.dart';
import 'package:union_shop/widgets/footer.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: const Color(0xFF4d2963),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: const Color(0xFF4d2963),
                child: const Text(
                  'UP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Welcome to the Union Shop!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'We\u2019re dedicated to giving you the very best University branded products, '
              'with a range of clothing and merchandise available to shop all year round! '
              'We even offer an exclusive personalisation service!',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 12),
            const Text(
              'All online purchases are available for delivery or instore collection!',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 12),
            const Text(
              'We hope you enjoy our products as much as we enjoy offering them to you. '
              'If you have any questions or comments, please don\u2019t hesitate to contact us at ',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.email_outlined),
              title: const Text('hello@upsu.net'),
              onTap: () {},
            ),
            const SizedBox(height: 12),
            const Text(
              'Happy shopping!',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 8),
            const Text(
              'The Union Shop & Reception Team',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            Footer(),
          ],
        ),
      ),
    );
  }
}

