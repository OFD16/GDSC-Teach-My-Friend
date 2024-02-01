import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../local_storage/auth_storage.dart';
import '../../providers/auth_user_provider.dart';
import '../../services/auth_services.dart';
import '../profile/components/profile_menu.dart';
import '../sign_in/sign_in_screen.dart';

class SettingsScreen extends StatelessWidget {
  static String routeName = "/settings";
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    AuthUserProvider authUserProvider =
        Provider.of<AuthUserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // ProfileMenu(
            //   text: "My Account",
            //   icon: "assets/icons/User Icon.svg",
            //   press: () => {
            //     print("authUser: ${authUserProvider.authUser!.toJson()}"),
            //   },
            // ),
            ProfileMenu(
              text: "Notifications",
              icon: "assets/icons/Bell.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Settings",
              icon: "assets/icons/Settings.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Help Center",
              icon: "assets/icons/Question mark.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: () {
                AuthService authService = AuthService();
                authService.signOut();
                authUserProvider.clearAuthUser();
                AuthStorage().removeAuthUser();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  SignInScreen.routeName,
                  (route) => false, // This predicate will remove all routes
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
