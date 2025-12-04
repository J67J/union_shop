import 'package:flutter/material.dart';
import 'package:union_shop/services/user_store.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Account'),
          backgroundColor: const Color(0xFF4d2963),
          bottom: const TabBar(
            tabs: [Tab(text: 'Login'), Tab(text: 'Register')],
          ),
        ),
        body: const TabBarView(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: _AuthForm(mode: _AuthMode.login),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: _AuthForm(mode: _AuthMode.register),
            ),
          ],
        ),
      ),
    );
  }
}

enum _AuthMode { login, register }

class _AuthForm extends StatefulWidget {
  final _AuthMode mode;
  const _AuthForm({required this.mode});

  @override
  State<_AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<_AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  final _nameCtl = TextEditingController();

  @override
  void dispose() {
    _emailCtl.dispose();
    _passCtl.dispose();
    _nameCtl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _doAuth();
  }

  Future<void> _doAuth() async {
    final email = _emailCtl.text.trim();
    final pass = _passCtl.text;
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(const SnackBar(content: Text('Processing...')));

    if (widget.mode == _AuthMode.register) {
      final displayName = _nameCtl.text.trim();
      final ok = await UserStore.instance.register(email, pass, displayName);
      if (!mounted) return;
      messenger.hideCurrentSnackBar();
      if (ok) {
        messenger.showSnackBar(const SnackBar(content: Text('Registration successful')));
        Navigator.of(context).pop();
      } else {
        messenger.showSnackBar(const SnackBar(content: Text('Email already registered')));
      }
    } else {
      final ok = await UserStore.instance.authenticate(email, pass);
      if (!mounted) return;
      messenger.hideCurrentSnackBar();
      if (ok) {
        messenger.showSnackBar(const SnackBar(content: Text('Login successful')));
        Navigator.of(context).pop();
      } else {
        messenger.showSnackBar(const SnackBar(content: Text('Invalid credentials')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRegister = widget.mode == _AuthMode.register;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailCtl,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _passCtl,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (v) => (v == null || v.length < 6) ? 'Password too short' : null,
          ),
          if (isRegister)
            const Padding(
              padding: EdgeInsets.only(top: 6.0),
              child: Text(
                'Password needs a minimum of 6 characters',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          if (isRegister) ...[
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameCtl,
              decoration: const InputDecoration(labelText: 'Display name'),
              validator: (v) => (v == null || v.isEmpty) ? 'Enter a name' : null,
            ),
          ],
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4d2963)),
            onPressed: _submit,
            child: Text(isRegister ? 'Create account' : 'Sign in'),
          ),
        ],
      ),
    );
  }
}
