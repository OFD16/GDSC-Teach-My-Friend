import 'package:Sharey/models/User.dart';
import 'package:flutter/material.dart';

class AuthUserProvider with ChangeNotifier {
  User? authUser;

  AuthUserProvider({this.authUser});

  void setAuthUser(User? user) {
    authUser = user;
    notifyListeners();
  }

  // Updater
  void updateAuthUser(User? user) {
    authUser = user;
    notifyListeners();
  }

  // Cleaner
  void clearAuthUser() {
    authUser = null;
    notifyListeners();
  }
}
