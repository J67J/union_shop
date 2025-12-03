import 'package:flutter/material.dart';
import 'package:union_shop/auth_page.dart';

class StaticNavbar extends StatefulWidget {
  const StaticNavbar({super.key});

  @override
  State<StaticNavbar> createState() => _StaticNavbarState();
}

class _StaticNavbarState extends State<StaticNavbar> {
  bool _collapsed = false;

  void _toggle() {
    setState(() {
      _collapsed = !_collapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = _collapsed ? 64.0 : 220.0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: width,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 64,
            color: const Color(0xFF4d2963),
            child: Row(
              children: [
                IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.menu),
                  onPressed: _toggle,
                ),
                if (!_collapsed)
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildItem(context, icon: Icons.collections_outlined, label: 'Collections', onTap: () => Navigator.pushNamed(context, '/gallery')),
          _buildItem(context, icon: Icons.info_outline, label: 'About Us', onTap: () => Navigator.pushNamed(context, '/about')),
          _buildItem(context, icon: Icons.local_offer_outlined, label: 'Sale!', onTap: () => Navigator.pushNamed(context, '/gallery')),
          const Spacer(),
          Divider(height: 1, color: Colors.grey[300]),
          _buildItem(context, icon: Icons.person_outline, label: 'Account', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthPage()))),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    if (_collapsed) {
      return IconButton(
        icon: Icon(icon, color: Colors.grey[800]),
        onPressed: onTap,
        tooltip: label,
      );
    }

    return ListTile(
      leading: Icon(icon, color: Colors.grey[800]),
      title: Text(label),
      onTap: onTap,
    );
  }
}
