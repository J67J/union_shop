import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRecord {
  final String email;
  final String password;
  final String displayName;

  UserRecord({required this.email, required this.password, required this.displayName});

  Map<String, String> toMap() => {'email': email, 'password': password, 'displayName': displayName};

  static UserRecord fromMap(Map<String, dynamic> m) => UserRecord(
        email: m['email'] as String,
        password: m['password'] as String,
        displayName: m['displayName'] as String,
      );
}

class UserStore {
  UserStore._private();
  static final UserStore instance = UserStore._private();

  static const _kKey = 'union_shop_registered_users_v1';

  final ValueNotifier<String?> currentUser = ValueNotifier<String?>(null);

  Future<Map<String, UserRecord>> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kKey);
    if (raw == null || raw.isEmpty) return {};
    final Map<String, dynamic> decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map((k, v) => MapEntry(k, UserRecord.fromMap(v as Map<String, dynamic>)));
  }

  Future<void> _saveAll(Map<String, UserRecord> map) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(map.map((k, v) => MapEntry(k, v.toMap())));
    await prefs.setString(_kKey, encoded);
  }

  /// Register a new user. Returns true if successful, false if email exists.
  Future<bool> register(String email, String password, String displayName) async {
    final users = await _loadAll();
    final key = email.toLowerCase();
    if (users.containsKey(key)) return false;
    users[key] = UserRecord(email: email, password: password, displayName: displayName);
    await _saveAll(users);
    currentUser.value = email;
    return true;
  }

  /// Authenticate existing user; returns true if credentials match.
  Future<bool> authenticate(String email, String password) async {
    final users = await _loadAll();
    final key = email.toLowerCase();
    final rec = users[key];
    if (rec == null) return false;
    final ok = rec.password == password;
    if (ok) currentUser.value = email;
    return ok;
  }

  /// Sign out
  void signOut() {
    currentUser.value = null;
  }

  /// Returns the display name for the given email, or null if not found.
  Future<String?> displayNameFor(String? email) async {
    if (email == null) return null;
    final users = await _loadAll();
    final rec = users[email.toLowerCase()];
    return rec?.displayName;
  }

  /// Update the display name for the given email. Returns true if updated.
  Future<bool> updateDisplayName(String email, String newDisplayName) async {
    final users = await _loadAll();
    final key = email.toLowerCase();
    final rec = users[key];
    if (rec == null) return false;
    users[key] = UserRecord(email: rec.email, password: rec.password, displayName: newDisplayName);
    await _saveAll(users);
    return true;
  }

  /// Change password for the given email. Returns true if successful.
  Future<bool> changePassword(String email, String oldPassword, String newPassword) async {
    final users = await _loadAll();
    final key = email.toLowerCase();
    final rec = users[key];
    if (rec == null) return false;
    if (rec.password != oldPassword) return false;
    users[key] = UserRecord(email: rec.email, password: newPassword, displayName: rec.displayName);
    await _saveAll(users);
    return true;
  }

  /// Delete the account for the given email if the password matches. Signs out after deletion.
  Future<bool> deleteAccount(String email, String password) async {
    final users = await _loadAll();
    final key = email.toLowerCase();
    final rec = users[key];
    if (rec == null) return false;
    if (rec.password != password) return false;
    users.remove(key);
    await _saveAll(users);
    currentUser.value = null;
    return true;
  }
}
