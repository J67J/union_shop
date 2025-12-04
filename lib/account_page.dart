import 'package:flutter/material.dart';
import 'package:union_shop/services/user_store.dart';
import 'package:union_shop/auth_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Future<void> _editDisplayName(String email) async {
    final ctl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit display name'),
        content: TextField(controller: ctl, decoration: const InputDecoration(labelText: 'Display name')),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Save')),
        ],
      ),
    );

    if (ok != true) return;
    if (!mounted) return;
    final newName = ctl.text.trim();
    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Name cannot be empty')));
      return;
    }
    final res = await UserStore.instance.updateDisplayName(email, newName);
    if (!mounted) return;
    if (res) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Display name updated')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to update name')));
    }
  }

  Future<void> _changePassword(String email) async {
    final oldCtl = TextEditingController();
    final newCtl = TextEditingController();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: oldCtl, decoration: const InputDecoration(labelText: 'Current password'), obscureText: true),
            TextField(controller: newCtl, decoration: const InputDecoration(labelText: 'New password'), obscureText: true),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Change')),
        ],
      ),
    );

    if (confirm != true) return;
    if (!mounted) return;
    final oldPass = oldCtl.text;
    final newPass = newCtl.text;
    if (newPass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('New password too short')));
      return;
    }
    final ok = await UserStore.instance.changePassword(email, oldPass, newPass);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password changed')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to change password (check current password)')));
    }
  }

  Future<void> _confirmDeleteAccount(String email) async {
    final passCtl = TextEditingController();
    final sure = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('This will permanently delete your account. Enter your password to confirm.'),
            TextField(controller: passCtl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (sure != true) return;
    if (!mounted) return;
    final ok = await UserStore.instance.deleteAccount(email, passCtl.text);
    if (ok) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account deleted')));
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to delete account (check password)')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4d2963),
        title: const Text('Account'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ValueListenableBuilder<String?>(
            valueListenable: UserStore.instance.currentUser,
            builder: (context, email, _) {
              if (email == null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Not signed in', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4d2963)),
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthPage())),
                      child: const Text('Sign in / Register'),
                    ),
                  ],
                );
              }

              return FutureBuilder<String?>(
                future: UserStore.instance.displayNameFor(email),
                builder: (context, snapshot) {
                  final displayName = snapshot.data ?? email.split('@').first;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hello, $displayName', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Signed in as: $email', style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 16),
                      const Text('Welcome back to Union Shop. Manage your account or sign out below.'),
                      const SizedBox(height: 24),

                      // Account actions
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4d2963)),
                        onPressed: () => _editDisplayName(email),
                        child: const Text('Edit display name'),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4d2963)),
                        onPressed: () => _changePassword(email),
                        child: const Text('Change password'),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () => _confirmDeleteAccount(email),
                        child: const Text('Delete account'),
                      ),

                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4d2963)),
                        onPressed: () {
                          UserStore.instance.signOut();
                          // After logout, send user to home/main menu
                          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                        },
                        child: const Text('Log out'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
