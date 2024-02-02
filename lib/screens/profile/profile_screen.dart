import 'package:Sharey/constants.dart';
import 'package:Sharey/providers/auth_user_provider.dart';
import 'package:Sharey/screens/profile/components/coupons_tab.dart';
import 'package:Sharey/screens/profile/components/lessons_tab.dart';
import 'package:Sharey/screens/profile/components/rate_card.dart';
import 'package:Sharey/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/lesson_services.dart';
import 'components/profile_pic.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";

  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  LessonService lessonService = LessonService();

  String currentTab = "Lessons";

  @override
  Widget build(BuildContext context) {
    AuthUserProvider authUserProvider =
        Provider.of<AuthUserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: authUserProvider.authUser != null
            ? [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () =>
                      Navigator.pushNamed(context, SettingsScreen.routeName),
                )
              ]
            : [],
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
              RateCard(rate: authUserProvider.authUser!.userRate),

              // Tab buttons
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40, // Set the height
                      width: 160, // Set the width
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle button press for "Lessons"
                          setState(() {
                            currentTab = "Lessons";
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: currentTab == "Lessons"
                              ? kPrimaryColor
                              : kPrimaryColor.withOpacity(0.7),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ), // Set the border radius here
                          ),
                        ),
                        child: const Text("Lessons"),
                      ),
                    ),
                    SizedBox(
                      height: 40, // Set the height
                      width: 160, // Set the width
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentTab = "Coupons";
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: currentTab == "Coupons"
                              ? kPrimaryColor
                              : kPrimaryColor.withOpacity(0.7),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ), // Set the border radius here
                          ),
                        ),
                        child: const Text("Coupons"),
                      ),
                    ),
                  ],
                ),
              ),

              currentTab == "Lessons" ? const LessonTab() : const CouponsTab(),
            ],
          ),
        ),
      ),
    );
  }
}
