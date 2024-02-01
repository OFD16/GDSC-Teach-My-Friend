import 'package:Sharey/constants.dart';
import 'package:Sharey/local_storage/auth_storage.dart';
import 'package:Sharey/providers/auth_user_provider.dart';
import 'package:Sharey/screens/profile/components/rate_card.dart';
import 'package:Sharey/screens/settings/settings_screen.dart';
import 'package:Sharey/screens/sign_in/sign_in_screen.dart';
import 'package:Sharey/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/profile_menu.dart';
import 'components/profile_pic.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";

  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String currentTab = "lessons";

  @override
  Widget build(BuildContext context) {
    AuthUserProvider authUserProvider =
        Provider.of<AuthUserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () =>
                Navigator.pushNamed(context, SettingsScreen.routeName),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const ProfilePic(),
              const SizedBox(height: 20),
              const Text("asigklaslşkagsşigas"),
              RateCard(rate: 4.7),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Expanded(
              //         child: ElevatedButton(
              //             onPressed: () {}, child: Text("lessons"))),
              //     Expanded(
              //         child: ElevatedButton(
              //             onPressed: () {}, child: Text("lessons"))),
              //   ],
              // ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 40, // Set the height
                    width: 160, // Set the width
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle button press for "Lessons"
                      },
                      child: const Text("Lessons"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ), // Set the border radius here
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 40, // Set the height
                    width: 160, // Set the width
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle button press for "Coupons"
                      },
                      child: Text("Coupons"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor.withOpacity(0.7),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ), // Set the border radius here
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
