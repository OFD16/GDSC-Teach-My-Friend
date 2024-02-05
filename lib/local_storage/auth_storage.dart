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

  setRememberMe(bool rememberMe) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("rememberMe", rememberMe);
  }

  Future<bool> getRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("rememberMe") ?? false;
  }

  setRememberMeEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("rememberMeEmail", email);
  }

  Future<String?> getRememberMeEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("rememberMeEmail");
  }

  setRememberMePassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("rememberMePassword", password);
  }

  Future<String?> getRememberMePassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("rememberMePassword");
  }

  Future<bool> pushNotificationsEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("pushNotificationsEnabled") ?? false;
  }

  setPushNotificationsEnabled(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("pushNotificationsEnabled", value);
  }

  Future<bool> emailNotificationsEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("emailNotificationsEnabled") ?? false;
  }

  setEmailNotificationsEnabled(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("emailNotificationsEnabled", value);
  }

  clearDatas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
