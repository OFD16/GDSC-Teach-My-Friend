import 'package:Sharey/providers/auth_user_provider.dart';
import 'package:Sharey/services/lesson_services.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../models/Lesson.dart';
import '../../create_content/components/education_card.dart';
import "../../create_content/data.dart";
import '../../create_content/text_input.dart';
import '../../home/components/categories.dart';

class UpdateLessonBottomSheet extends StatefulWidget {
  final Lesson lesson;

  const UpdateLessonBottomSheet({super.key, required this.lesson});
  @override
  _UpdateLessonBottomSheetState createState() =>
      _UpdateLessonBottomSheetState();
}

class _UpdateLessonBottomSheetState extends State<UpdateLessonBottomSheet> {
  int initialPage = 0;
  int selectedCategory = 0;
  List<String> images = [];
  String levelText = "", studentText = "", typeText = "";
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<List<Map<String, dynamic>>> categoriesList = [
    sportList,
    lessonList,
    artList,
    musicList,
    sportList
  ];
  void clearSelectedCategory() {
    for (List<Map<String, dynamic>> categoryList in categoriesList) {
      // Iterate through each item in the category list
      for (Map<String, dynamic> item in categoryList) {
        // Set "isSelect" to false for each item
        item["isSelect"] = false;
      }
    }
    typeText = "";
    images = [];
  }

  void onPressOnCategories(int tab) {
    setState(() {
      selectedCategory = tab;
    });
  }

  void onPressOnEducation(Map<String, dynamic> cat) {
    setState(() {
      if (cat["isSelect"] == false) {
        clearSelectedCategory();
        cat["isSelect"] = true;
        typeText = cat["title"];
        images.add(cat["image"]!);
      } else {
        cat["isSelect"] = false;
        typeText = "";
        images = [];
      }
    });
  }

  int calculatePoints() {
    // Total point will be calculated based on the level and student count
    int points = 0;

    // Assign points based on the level
    switch (levelText) {
      case "Beginner":
        points += 25;
        break;
      case "Intermediate":
        points += 35;
        break;
      case "Advanced":
        points += 55;
        break;
      default:
        points += 0;
    }

    // Assign additional points based on the student count
    switch (studentText) {
      case "1":
        points += 5;
        break;
      case "1-4":
        points += 15;
        break;
      case "4-8":
        points += 25;
        break;
      case "8-12":
        points += 45;
        break;
      default:
        points += 0;
    }

    // Assign additional points based on the selected education category
    for (final category in categoriesList) {
      for (final education in category) {
        if (education["isSelect"] == true) {
          points += education["point"] as int;
        }
      }
    }

    return points * 2;
  }

  void updateLesson() {
    print("widget.lesson : ${widget.lesson.toJson()}");
    Lesson updatedLesson = widget.lesson;
    print("UpdatedLesson 1: ${updatedLesson.toJson()}");
    updatedLesson.title = titleController.text;
    updatedLesson.description = descriptionController.text;
    updatedLesson.level = levelText;
    updatedLesson.userLimit = studentText;
    updatedLesson.pricePoint = calculatePoints();
    updatedLesson.type = typeText;
    updatedLesson.images = images;

    LessonService().updateLesson(updatedLesson.id, updatedLesson);
    Navigator.pop(context);
    // Create teaching content
  }

  @override
  void initState() {
    super.initState();
    titleController.text = widget.lesson.title!;
    descriptionController.text = widget.lesson.description!;
    levelText = widget.lesson.level!;
    studentText = widget.lesson.userLimit!;
    typeText = widget.lesson.type!;
    images = widget.lesson.images!;

    for (int i = 0; i < categoriesList.length; i++) {
      for (int j = 0; j < categoriesList[i].length; j++) {
        final item = categoriesList[i][j];
        if (item["title"] == widget.lesson.type) {
          // Store the indices or take any other action
          setState(() {
            selectedCategory = i;
            initialPage = j;
            item["isSelect"] = true;
          });
          return; // Optional: If you want to stop searching after finding the item
        }
      }
    }
  }

  Widget build(BuildContext context) {
    AuthUserProvider authUserProvider =
        Provider.of<AuthUserProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text("Select a category: "),
        ),
        // Categories component
        Categories(
          selected: selectedCategory,
          onTabChanged: (tab) {
            onPressOnCategories(tab);
          },
        ),
        // CarouselSlider component
        CarouselSlider(
          items: categoriesList[selectedCategory].map<Widget>((cat) {
            return Builder(
              builder: (BuildContext context) {
                return EducationCard(
                  education: cat,
                  onTap: () => onPressOnEducation(cat),
                  isSelected: cat["isSelect"],
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
            height: 150,
            aspectRatio: 16 / 9,
            viewportFraction: 0.8,
            initialPage: initialPage,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: false,
            autoPlayInterval: const Duration(milliseconds: 800),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            scrollDirection: Axis.horizontal,
          ),
        ),
        const SizedBox(height: 20),
        // TextInput components
        TextInput(
          title: "Title",
          hintText: "Title of your content",
          controller: titleController,
        ),
        TextInput(
          title: "Description",
          hintText: "Description of your content",
          controller: descriptionController,
        ),
        // Select a level
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                "Select a level:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...levels
                        .map((level) => Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: ChoiceChip(
                                label: Text(level["text"]!),
                                selected: levelText == level["text"],
                                onSelected: (bool selected) {
                                  setState(() {
                                    levelText = level["text"]!;
                                  });
                                },
                              ),
                            ))
                        .toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Select a max student
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                "Select a max student:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...studentCount
                        .map((studentLimit) => Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: ChoiceChip(
                                label: Text(studentLimit["text"]! + " person"),
                                selected: studentText == studentLimit["text"],
                                onSelected: (bool selected) {
                                  setState(() {
                                    studentText = studentLimit["text"]!;
                                  });
                                },
                              ),
                            ))
                        .toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Total points and submit button
        levelText != "" && studentText != ""
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: "Total:\n",
                          children: [
                            WidgetSpan(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 4.0, left: 4.0),
                                child: Row(children: [
                                  Text(
                                    calculatePoints().toString(),
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                  const SizedBox(width: 4),
                                  SvgPicture.asset(
                                    "assets/icons/point.svg",
                                    height: 16,
                                    width: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    "Points",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  )
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => updateLesson(),
                        child: const Text("Update Lesson"),
                      ),
                    )
                  ],
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
