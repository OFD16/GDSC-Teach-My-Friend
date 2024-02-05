import 'package:Sharey/models/Lesson.dart';
import 'package:Sharey/models/User.dart';
import 'package:Sharey/screens/profile/profile_screen.dart';
import 'package:Sharey/services/lesson_services.dart';
import 'package:Sharey/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../providers/auth_user_provider.dart';

class ProductDescription extends StatefulWidget {
  ProductDescription({
    Key? key,
    this.pressOnSeeMore,
    this.lesson,
    this.isFavourite = false,
    this.user,
  }) : super(key: key);

  final Lesson? lesson;
  bool isFavourite;
  final User? user;
  final GestureTapCallback? pressOnSeeMore;

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  LessonService lessonService = LessonService();
  void likeLesson(Lesson lesson) async {
    User authUser =
        Provider.of<AuthUserProvider>(context, listen: false).authUser!;

    await lessonService.likeLesson(lesson.id!, authUser.id!);
  }

  void unlikeLesson(Lesson lesson) async {
    User authUser =
        Provider.of<AuthUserProvider>(context, listen: false).authUser!;

    await lessonService.unlikeLesson(lesson.id!, authUser.id!);
  }

  @override
  Widget build(BuildContext context) {
    print("isliked: ${widget.isFavourite}");
    print("is contains ${widget.lesson?.likes.contains(widget.user?.id)}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "${widget.lesson?.title}",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              child: InkWell(
                onTap: () => Navigator.pushNamed(
                  context,
                  ProfileScreen.routeName,
                  arguments: ProfilesArguments(user: widget.user),
                ),
                child: Row(children: [
                  CircleAvatar(
                    backgroundImage: widget.user != null &&
                            widget.user?.photoUrl != null &&
                            widget.user?.photoUrl != ""
                        ? NetworkImage(widget.user!.photoUrl!) as ImageProvider
                        : const AssetImage("assets/images/profile_image.jpg"),
                    radius: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${widget.user?.firstName} ${widget.user?.lastName}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ]),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  if (widget.lesson!.likes.contains(widget.user?.id)) {
                    widget.lesson!.likes.remove(widget.user?.id);
                    unlikeLesson(widget.lesson!);
                    widget.isFavourite = false;
                  } else {
                    widget.lesson!.likes.add(widget.user!.id!);
                    likeLesson(widget.lesson!);
                    widget.isFavourite = true;
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                width: 48,
                decoration: BoxDecoration(
                  color: widget.isFavourite
                      ? const Color(0xFFFFE6E6)
                      : const Color(0xFFF5F6F9),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: SvgPicture.asset(
                  "assets/icons/Heart Icon_2.svg",
                  colorFilter: ColorFilter.mode(
                      widget.isFavourite
                          ? const Color(0xFFFF4848)
                          : const Color(0xFFDBDEE4),
                      BlendMode.srcIn),
                  height: 16,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 64,
          ),
          child: Text(
            widget.lesson?.description ?? "",
            maxLines: 3,
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(
        //     horizontal: 20,
        //     vertical: 12,
        //   ),
        //   child: GestureDetector(
        //     onTap: () {},
        //     child: const Row(
        //       children: [
        //         Text(
        //           "See More Detail",
        //           style: TextStyle(
        //               fontWeight: FontWeight.w600, color: kPrimaryColor),
        //         ),
        //         SizedBox(width: 5),
        //         Icon(
        //           Icons.arrow_forward_ios,
        //           size: 12,
        //           color: kPrimaryColor,
        //         ),
        //       ],
        //     ),
        //   ),
        // )
      ],
    );
  }
}
