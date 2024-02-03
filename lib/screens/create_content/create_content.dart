import 'package:Sharey/screens/create_content/components/custom_content_card.dart';
import 'package:Sharey/screens/init_screen.dart';

import 'package:Sharey/providers/auth_user_provider.dart';
import 'package:Sharey/screens/create_content/components/education_card.dart';
import 'package:Sharey/screens/create_content/text_input.dart';
import '../home/components/categories.dart';

import 'package:Sharey/services/lesson_services.dart';
import 'package:provider/provider.dart';

import '../../models/Lesson.dart';
import '../../models/User.dart';
import 'package:Sharey/constants.dart';
import "./data.dart";

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CreateContentScreen extends StatefulWidget {
  static String routeName = "/create_content";

  const CreateContentScreen({Key? key}) : super(key: key);

  @override
  State<CreateContentScreen> createState() => _CreateContentScreenState();
}

class _CreateContentScreenState extends State<CreateContentScreen> {
  LessonService lessonService = LessonService();

  List<List<Map<String, dynamic>>> categoriesList = [
    sportList,
    lessonList,
    artList,
    musicList,
    [
      {
        "title": "Custom",
        "image": "assets/icons/image_gallery.svg",
        "isSelect": false,
        "point": 0
      }
    ]
  ];

  int selectedCategory = 0;
  List<String> images = [];
  String levelText = "", studentText = "", typeText = "";
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  void initState() {
    super.initState();
    clearSelectedCategory();
  }

  Future<void> createTeachingContent(User authUser) async {
    Lesson lesson = Lesson(
      ownerId: authUser.id,
      level: levelText,
      title: titleController.text,
      description: descriptionController.text,
      images: images,
      type: typeText,
      userLimit: studentText,
      pricePoint: calculatePoints(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (lesson.title != "" && lesson.description != "" && lesson.type != "") {
      await lessonService.createLesson(lesson).then((value) => {
            // print("value is ${value}"),
            setState(() {
              clearSelectedCategory();
            }),
            Navigator.pushNamed(context, InitScreen.routeName),
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text("Your teaching content has been created"),
              ),
            ),
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in the title, description and category"),
        ),
      );
    }
  }

  void clearSelectedCategory() {
    for (List<Map<String, dynamic>> categoryList in categoriesList) {
      // Iterate through each item in the category list
      for (Map<String, dynamic> item in categoryList) {
        // Set "isSelect" to false for each item
        item["isSelect"] = false;
      }
    }
  }

  void onPressOnCategories(int tab) {
    print("currentTab: $tab");
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

  @override
  Widget build(BuildContext context) {
    AuthUserProvider authUserProvider =
        Provider.of<AuthUserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Teaching Content",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: kPrimaryColor),
        ),
        centerTitle: true,
        backgroundColor: kPrimaryLightColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                    "Select a category: "), // context.watch<AuthUserProvider>().authUser!.toJson()
              ),
              Categories(
                selected: selectedCategory,
                onTabChanged: (tab) {
                  onPressOnCategories(tab);
                },
              ),
              CarouselSlider(
                items: categoriesList[selectedCategory].map<Widget>((cat) {
                  print("selectedCategory: $selectedCategory");
                  return Builder(
                    builder: (BuildContext context) {
                      if (selectedCategory == 4) {
                        return CustomContentCard(
                          onImageUploaded: (data) {
                            print("data: $data");
                            setState(() {
                              images = data["imageUrls"];
                              typeText = data["type"];
                            });
                          },
                        );
                      } else {
                        return EducationCard(
                          education: cat,
                          onTap: () => onPressOnEducation(cat),
                          isSelected: cat["isSelect"],
                        );
                      }
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 150,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  // enableInfiniteScroll: true,
                  // reverse: false,
                  // autoPlay: false,
                  // autoPlayInterval: const Duration(milliseconds: 800),
                  // autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  //onPageChanged: callbackFunction,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              const SizedBox(height: 20),
              selectedCategory == 4
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: Text("Select a max student:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ...types
                                    .map((type) => Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: ChoiceChip(
                                            label: Text(type),
                                            selected: typeText == type,
                                            onSelected: (bool selected) {
                                              setState(() {
                                                typeText = type;
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
                    )
                  : const SizedBox(),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text("Select a level:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text("Select a max student:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
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
                                      label: Text(
                                          studentLimit["text"]! + " person"),
                                      selected:
                                          studentText == studentLimit["text"],
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
              levelText != "" && studentText != ""
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
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
                                              fontSize: 16,
                                              color: Colors.black),
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
                                              fontSize: 14,
                                              color: Colors.black),
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
                              onPressed: () => createTeachingContent(
                                  authUserProvider.authUser!),
                              child: const Text("Submit"),
                            ),
                          )
                        ],
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
