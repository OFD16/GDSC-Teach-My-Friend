import 'package:Sharey/constants.dart';
import 'package:Sharey/local_storage/auth_storage.dart';
import 'package:Sharey/providers/auth_provider.dart';
import 'package:Sharey/providers/auth_user_provider.dart';
import 'package:Sharey/screens/profile/components/coupons_tab.dart';
import 'package:Sharey/screens/profile/components/lessons_tab.dart';
import 'package:Sharey/screens/profile/components/rate_card.dart';
import 'package:Sharey/screens/settings/settings_screen.dart';
import 'package:Sharey/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/User.dart';
import '../../services/lesson_services.dart';
import 'components/profile_pic.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";

  ProfileScreen({super.key, this.user});
  User? user;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  LessonService lessonService = LessonService();

  String currentTab = "Lessons";

  UserService userService = UserService();

  void didChangeDependencies() async {
    super.didChangeDependencies();

    // Get the arguments
    ProfilesArguments? args =
        ModalRoute.of(context)?.settings.arguments as ProfilesArguments?;

    // Check if the arguments are not null
    if (args != null) {
      // Update the user in the widget
      setState(() {
        widget.user = args.user;
      });

      // Trigger a rebuild after user data is fetched
      print("user in profile screen: ${widget.user!.toJson()}");
    } else {
      // If the arguments are null, get the user from the provider
      AuthUserProvider authUserProvider =
          Provider.of<AuthUserProvider>(context, listen: false);
      if (authUserProvider.authUser != null) {
        getUser(authUserProvider.authUser!.id!);

        print("user in profile screen: ${widget.user!.toJson()}");
      }
    }
  }

  void getUser(String userId) async {
    User? user = await userService.getUser(userId);
    AuthStorage authStorage = AuthStorage();
    AuthUserProvider authUserProvider =
        Provider.of<AuthUserProvider>(context, listen: false);
    if (user != null) {
      setState(() {
        widget.user = user;
        authStorage.setAuthUser(user);
        authUserProvider.setAuthUser(user);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthUserProvider authUserProvider =
        Provider.of<AuthUserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: widget.user != null &&
                widget.user!.id == authUserProvider.authUser?.id
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
              Text("${widget.user?.firstName} ${widget.user?.lastName}"),
              RateCard(rate: widget.user?.userRate),

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

              currentTab == "Lessons"
                  ? LessonTab(user: widget.user)
                  : CouponsTab(user: widget.user),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilesArguments {
  User? user;

  ProfilesArguments({required this.user});
}
