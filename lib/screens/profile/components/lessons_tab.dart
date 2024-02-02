import 'package:Sharey/providers/auth_user_provider.dart';
import 'package:Sharey/screens/profile/components/update_lesson_bottomsheet.dart';
import 'package:Sharey/services/lesson_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../models/Lesson.dart';

class LessonTab extends StatefulWidget {
  const LessonTab({super.key});

  @override
  State<LessonTab> createState() => _LessonTabState();
}

class _LessonTabState extends State<LessonTab> {
  LessonService lessonService = LessonService();
  late AuthUserProvider authUserProvider;
  List<Lesson> lessons = [];

  @override
  void initState() {
    super.initState();
    authUserProvider = Provider.of<AuthUserProvider>(context, listen: false);
    String? userId = authUserProvider.authUser?.id;

    if (userId != null) {
      getLessons(userId);
    }
  }

  Future<List<Lesson>> getLessons(String id) async {
    lessonService.getUserLessons(id).then((value) {
      setState(() {
        lessons = value ?? [];
      });
    });
    return lessons;
  }

  @override
  Widget build(BuildContext context) {
    AuthUserProvider authUserProvider =
        Provider.of<AuthUserProvider>(context, listen: false);

    return ListView.builder(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                lesson.ownerId == authUserProvider.authUser!.id
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
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16))),
                                  builder: (context) =>
                                      DraggableScrollableSheet(
                                    minChildSize: 0.2,
                                    expand: false,
                                    builder: (_, controller) => ListView(
                                      controller: controller,
                                      children: [
                                        Icon(
                                          Icons.remove,
                                          color: Colors.grey[600],
                                        ),
                                        Expanded(
                                          child: UpdateLessonBottomSheet(
                                              lesson: lesson),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                lessonService.deleteLesson(lesson.id!);
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
    );
  }
}