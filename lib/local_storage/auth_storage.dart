import 'package:Sharey/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const _authKey = "authKey";

  setAuthUser(User authUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authKey, authUser.toJson().toString());
  }

  clearAuthUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authKey);
  }

  getAuthUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authUserJson = prefs.getString(_authKey);
    if (authUserJson != null) {
      return User.fromJson(authUserJson as Map<String, dynamic>);
    }
    return null;
  }
}
