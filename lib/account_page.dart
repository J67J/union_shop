import 'package:flutter/material.dart';
import 'package:union_shop/services/user_store.dart';
import 'package:union_shop/auth_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
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
                      const Divider(),
                      const SizedBox(height: 12),
                      const Text('Sign in with (placeholders):'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
                            icon: Image.network('https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg', width: 18, height: 18),
                            label: const Text('Google'),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Google sign-in not configured')));
                            },
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
                            icon: const Icon(Icons.facebook, size: 18),
                            label: const Text('Facebook'),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Facebook sign-in not configured')));
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4d2963)),
                        onPressed: () {
                          UserStore.instance.signOut();
                          // After logout, send user to AuthPage
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const AuthPage()), (route) => false);
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
