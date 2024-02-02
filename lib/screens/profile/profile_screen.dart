import 'package:Sharey/constants.dart';
import 'package:Sharey/local_storage/auth_storage.dart';
import 'package:Sharey/models/Lesson.dart';
import 'package:Sharey/providers/auth_user_provider.dart';
import 'package:Sharey/screens/profile/components/rate_card.dart';
import 'package:Sharey/screens/profile/components/update_lesson_bottomsheet.dart';
import 'package:Sharey/screens/settings/settings_screen.dart';
import 'package:Sharey/screens/sign_in/sign_in_screen.dart';
import 'package:Sharey/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/User.dart';
import '../../services/lesson_services.dart';
import '../create_content/data.dart';
import 'components/profile_menu.dart';
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
  late AuthUserProvider authUserProvider;
  List<Lesson> lessons = [];

  Future<List<Lesson>> getLessons(String id) async {
    lessonService.getuserlessons(id).then((value) {
      setState(() {
        lessons = value ?? [];
      });
    });
    return lessons;
  }

  @override
  void initState() {
    super.initState();
    authUserProvider = Provider.of<AuthUserProvider>(context, listen: false);
    String? userId = authUserProvider.authUser?.id;

    if (userId != null) {
      getLessons(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              RateCard(rate: authUserProvider.authUser!.userRate),

              // Tab buttons
              Row(
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

              currentTab == "Lessons"
                  ? Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: lessons.length,
                        itemBuilder: (context, index) {
                          Lesson lesson = lessons[index];
                          return Container(
                            padding: const EdgeInsets.all(4),
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: kPrimaryColor),
                              borderRadius: BorderRadius.circular(10),
                              color: kPrimaryLightColor,
                            ),
                            child: ListTile(
                              leading: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: AssetImage(lesson.images![0]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      lesson.title!,
                                      softWrap: false,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  lesson.ownerId ==
                                          authUserProvider.authUser!.id
                                      ? Flexible(
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    isDismissible: true,
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        16))),
                                                    builder: (context) =>
                                                        DraggableScrollableSheet(
                                                      minChildSize: 0.2,
                                                      expand: false,
                                                      builder:
                                                          (_, controller) =>
                                                              ListView(
                                                        controller: controller,
                                                        children: [
                                                          Icon(
                                                            Icons.remove,
                                                            color: Colors
                                                                .grey[600],
                                                          ),
                                                          Expanded(
                                                            child:
                                                                UpdateLessonBottomSheet(
                                                                    lesson:
                                                                        lesson),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );

                                                  // Scaffold.of(context)
                                                  //     .showBottomSheet<
                                                  //         void>(
                                                  //   (BuildContext context) {
                                                  //     return Container(
                                                  //       height: 700,
                                                  //       decoration:
                                                  //           const BoxDecoration(
                                                  //         color:
                                                  //             kPrimaryLightColor,
                                                  //         borderRadius:
                                                  //             BorderRadius
                                                  //                 .only(
                                                  //           topLeft: Radius
                                                  //               .circular(
                                                  //                   20),
                                                  //           topRight: Radius
                                                  //               .circular(
                                                  //                   20),
                                                  //         ),
                                                  //         border: Border(
                                                  //           top: BorderSide(
                                                  //               color:
                                                  //                   kPrimaryColor,
                                                  //               width: 1),
                                                  //         ),
                                                  //       ),
                                                  //       child: Center(
                                                  //         child: Column(
                                                  //           mainAxisAlignment:
                                                  //               MainAxisAlignment
                                                  //                   .center,
                                                  //           mainAxisSize:
                                                  //               MainAxisSize
                                                  //                   .min,
                                                  //           children: <Widget>[
                                                  //             UpdateLessonBottomSheet(
                                                  //                 lesson:
                                                  //                     lesson),
                                                  //             ElevatedButton(
                                                  //               child: const Text(
                                                  //                   'Close BottomSheet'),
                                                  //               onPressed:
                                                  //                   () {
                                                  //                 Navigator.pop(
                                                  //                     context);
                                                  //               },
                                                  //             ),
                                                  //           ],
                                                  //         ),
                                                  //       ),
                                                  //     );
                                                  //   },
                                                  // );
                                                },
                                                icon: const Icon(Icons.edit),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete),
                                                onPressed: () {
                                                  lessonService
                                                      .deleteLesson(lesson.id!);
                                                  setState(() {
                                                    lessons.removeAt(index);
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                              subtitle: Text(
                                lesson.description!,
                                maxLines: 3,
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              hoverColor: kPrimaryColor,
                              onTap: () {
                                // Handle tap
                              },
                            ),
                          );
                        },
                      ),
                    )
                  : const Column(
                      children: [
                        Text("copupns page"),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
