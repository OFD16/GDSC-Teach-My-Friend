import 'package:Sharey/models/Lesson.dart';
import 'package:Sharey/services/lesson_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/product_card.dart';
import '../../../models/User.dart';
import '../../../providers/auth_user_provider.dart';
import '../../details/details_screen.dart';
import '../../products/products_screen.dart';
import 'section_title.dart';

class PopularProducts extends StatefulWidget {
  PopularProducts({super.key});

  @override
  State<PopularProducts> createState() => _PopularProductsState();
}

class _PopularProductsState extends State<PopularProducts> {
  LessonService lessonService = LessonService();

  late List<Lesson> initLessons = [];

  bool isLoading = true;

  Future<void> _fetchFeed() async {
    setState(() {
      isLoading = true;
    });
    List<Lesson> lessons = await lessonService.getLessons();
    setState(() {
      initLessons = lessons;
      isLoading = false;
    });
  }

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

  void initState() {
    super.initState();
    _fetchFeed();
  }

  @override
  Widget build(BuildContext context) {
    AuthUserProvider authUserProvider =
        Provider.of<AuthUserProvider>(context, listen: false);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Popular Trainings",
            press: () {
              Navigator.pushNamed(
                context,
                ProductsScreen.routeName,
                arguments: ProductsArguments(lessons: initLessons),
              );
            },
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(
                initLessons.length,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: ProductCard(
                      isFavourite: initLessons[index]
                          .likes!
                          .contains(authUserProvider.authUser!.id),
                      lesson: initLessons[index],
                      onFavouritePress: () {
                        setState(() {
                          if (initLessons[index]
                              .likes
                              .contains(authUserProvider.authUser!.id)) {
                            initLessons[index]
                                .likes
                                .remove(authUserProvider.authUser!.id);
                            unlikeLesson(initLessons[index]);
                          } else {
                            initLessons[index]
                                .likes
                                .add(authUserProvider.authUser!.id!);
                            likeLesson(initLessons[index]);
                          }
                        });
                      },
                      onPress: () => Navigator.pushNamed(
                        context,
                        DetailsScreen.routeName,
                        arguments:
                            ProductDetailsArguments(lesson: initLessons[index]),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 20),
            ],
          ),
        )
      ],
    );
  }
}
