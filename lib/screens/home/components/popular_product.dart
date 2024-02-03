import 'package:Sharey/models/Lesson.dart';
import 'package:Sharey/services/lesson_services.dart';
import 'package:flutter/material.dart';

import '../../../components/product_card.dart';
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

  void initState() {
    super.initState();
    _fetchFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Popular Trainings",
            press: () {
              Navigator.pushNamed(context, ProductsScreen.routeName);
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
                      isFavourite: false,
                      lesson: initLessons[index],
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
