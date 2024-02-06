import 'package:Sharey/screens/settings/components/admin_settings.dart';
import 'package:Sharey/screens/settings/components/help_center.dart';
import 'package:Sharey/screens/settings/components/notification_settings.dart';
import 'package:Sharey/screens/settings/components/user_info_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    void openBottomSheet(Widget content) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
        builder: (context) => DraggableScrollableSheet(
          minChildSize: 0.2,
          expand: false,
          builder: (_, controller) => ListView(
            controller: controller,
            children: [
              Icon(
                Icons.remove,
                color: Colors.grey[600],
              ),
              Container(
                height: 900,
                child: content,
              ),
            ],
          ),
        ),
      );
    }

    void logOut() {
      AuthService authService = AuthService();
      FirebaseAuth.instance.signOut();
      authService.signOut();
      authUserProvider.clearAuthUser();
      AuthStorage().removeAuthUser();
      Navigator.pushNamedAndRemoveUntil(
        context,
        SignInScreen.routeName,
        (route) => false, // This predicate will remove all routes
      );
    }

    List menuItems = [
      {
        "text": "My Account",
        "icon": "assets/icons/User Icon.svg",
        "press": () => openBottomSheet(const UserInfoSettings()),
        "isShow": true,
      },
      {
        "text": "Notifications",
        "icon": "assets/icons/Bell.svg",
        "press": () => openBottomSheet(const NotificationSettings()),
        "isShow": true,
      },
      {
        "text": "Admin Panel",
        "icon": "assets/icons/admin.svg",
        "press": () => openBottomSheet(const AdminSettings()),
        "isShow": authUserProvider.authUser!.isAdmin != null &&
                authUserProvider.authUser!.isAdmin == true
            ? true
            : false,
      },
      {
        "text": "Help Center",
        "icon": "assets/icons/Question mark.svg",
        "press": () => openBottomSheet(const HelpCenter()),
        "isShow": true,
      },
      {
        "text": "Log Out",
        "icon": "assets/icons/Log out.svg",
        "press": () => logOut(),
        "isShow": true,
      },
    ];

    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) => menuItems[index]["isShow"] ?? true
                ? ProfileMenu(
                    text: menuItems[index]["text"],
                    icon: menuItems[index]["icon"],
                    press: menuItems[index]["press"],
                  )
                : const SizedBox.shrink()));
  }
}
