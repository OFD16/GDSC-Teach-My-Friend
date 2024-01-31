import 'dart:convert';

import 'package:Sharey/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const _authKey = "authKey";

  setAuthUser(User authUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> authUserMap = authUser.toJson();
    String encodedAuthUser = json.encode(authUserMap);
    await prefs.setString(_authKey, encodedAuthUser);
  }

  removeAuthUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authKey);
  }

  Future<User?> getAuthUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authUserJsonString = prefs.getString(_authKey);

    if (authUserJsonString != null) {
      Map<String, dynamic> decodedAuthUser = json.decode(authUserJsonString);
      return User.fromJson(decodedAuthUser);
    }
    return null;
  }
}
