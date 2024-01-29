import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> login(String email, String password) async {
    // Simulate an API call for login
    await Future.delayed(Duration(seconds: 2));

    // Perform login logic here
    // ...

    // Update the isLoggedIn status
    _isLoggedIn = true;

    notifyListeners();
  }

  Future<void> logout() async {
    // Simulate an API call for logout
    await Future.delayed(Duration(seconds: 2));

    // Perform logout logic here
    // ...

    // Update the isLoggedIn status
    _isLoggedIn = false;

    notifyListeners();
  }
}
