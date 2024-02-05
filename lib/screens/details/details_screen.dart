import 'package:Sharey/constants.dart';
import 'package:Sharey/models/Lesson.dart';
import 'package:Sharey/models/User.dart';
import 'package:Sharey/providers/auth_user_provider.dart';
import 'package:Sharey/screens/cart/cart_screen.dart';
import 'package:Sharey/screens/create_content/data.dart';
import 'package:Sharey/services/lesson_services.dart';
import 'package:Sharey/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'components/color_dots.dart';
import 'components/product_description.dart';
import 'components/product_images.dart';
import 'components/students_container.dart';
import 'components/top_rounded_container.dart';

class DetailsScreen extends StatefulWidget {
  static String routeName = "/details";

  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  UserService userService = UserService();
  LessonService lessonService = LessonService();
  User? user;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    ProductDetailsArguments args =
        ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments;
    user = await getUser(args.lesson.ownerId!);
    print("user in get user: $user");
    setState(() {}); // Trigger a rebuild after user data is fetched
  }

  Future<User?> getUser(String ownerId) async {
    return await userService.getUser(ownerId);
  }

  void initUser() async {
    ProductDetailsArguments args =
        ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments;
    user = await getUser(args.lesson.ownerId!);
    setState(() {}); // Trigger a rebuild after user data is fetched
  }

  void leaveLesson(String studentId) {
    Lesson tempLesson =
        (ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments)
            .lesson;

    (ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments)
        .lesson = tempLesson;
    tempLesson.students!.removeWhere(
        (element) => element == studentId); // remove the current user

    lessonService.updateLesson(tempLesson.id, tempLesson).then((value) => {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('You have left the lesson!'),
            ),
          ),
        });
  }

  void joinLesson(String studentId) async {
    Lesson tempLesson =
        (ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments)
            .lesson;

    tempLesson.students!.add(studentId);

    (ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments)
        .lesson = tempLesson;
    await lessonService
        .updateLesson(tempLesson.id, tempLesson)
        .then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('You have joined the lesson!'),
                ),
              ),
            });
  }

  @override
  Widget build(BuildContext context) {
    final ProductDetailsArguments agrs =
        ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments;

    AuthUserProvider authUserProvider =
        Provider.of<AuthUserProvider>(context, listen: false);

    final lesson = agrs.lesson;
    print("user data: $user");

    bool isJoined =
        lesson.students!.contains(authUserProvider.authUser?.id ?? "");
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Text(
                      user != null ? user!.userRate.toString() : "4.0",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    SvgPicture.asset("assets/icons/Star Icon.svg"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          ProductImages(
            images: lesson.images!,
          ),
          TopRoundedContainer(
            color: Colors.white,
            child: Column(
              children: [
                ProductDescription(
                  // pressOnFavourite: () {
                  //   if (lesson.likes.contains(user?.id)) {
                  //     lesson.likes.remove(user?.id);
                  //   } else {
                  //     lesson.likes.add(user!.id!);
                  //   }
                  // },
                  pressOnSeeMore: () {},
                  lesson: lesson,
                  isFavourite: lesson.likes.contains(user?.id),
                  user: user,
                ),
                TopRoundedContainer(
                  color: const Color(0xFFF6F7F9),
                  child: Column(
                    children: [
                      ColorDots(lesson: lesson),
                      StudentContainer(lesson: lesson),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: TopRoundedContainer(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: isJoined ? kSecondaryColor : kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              onPressed: isJoined
                  ? () {
                      leaveLesson(authUserProvider.authUser!.id!);
                      setState(() {
                        isJoined = false;
                      });
                      // Navigator.pushNamed(context, CartScreen.routeName);
                    }
                  : () {
                      joinLesson(authUserProvider.authUser!.id!);
                      setState(() {
                        isJoined = true;
                      });
                    },
              child: Text(isJoined ? "Leave the lesson" : "Join the lesson"),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductDetailsArguments {
  Lesson lesson;

  ProductDetailsArguments({required this.lesson});
}
