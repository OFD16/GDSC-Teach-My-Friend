import 'package:Sharey/constants.dart';
import 'package:Sharey/screens/create_content/components/education_card.dart';
import '../home/components/categories.dart';

import "./data.dart";

import 'package:Sharey/services/feed_services.dart';
import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';

class CreateContentScreen extends StatefulWidget {
  static String routeName = "/create_content";

  const CreateContentScreen({Key? key}) : super(key: key);

  @override
  State<CreateContentScreen> createState() => _CreateContentScreenState();
}

class _CreateContentScreenState extends State<CreateContentScreen> {
  FeedService couponService = FeedService();
  late List<String> initCouponIDs = []; //"8BwXMNVrrYCI5gZY4let"
  bool isLoading = true;

  List<int> tabs = [0, 1, 2, 3, 4];
  int selectedCategory = 1;
  Future<void> _fetchFeed() async {
    setState(() {
      isLoading = true;
    });
    List<String> ids = await couponService.getCouponList();
    setState(() {
      initCouponIDs = ids;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // _fetchFeed();
  }

  void onPressOnCategories(int tab) {
    setState(() {
      isLoading = true;
    });

    setState(() {
      selectedCategory = tabs[tab];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Content"),
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
                child: Text("Select a category:"),
              ),
              Categories(
                  selected: selectedCategory,
                  press: () => onPressOnCategories(4)),
              CarouselSlider(
                items: artList.map((sport) {
                  return Builder(
                    builder: (BuildContext context) {
                      return EducationCard(education: sport);
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 200,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  //onPageChanged: callbackFunction,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              // CarouselSlider.builder(
              //   itemCount: 15,
              //   itemBuilder:
              //       (BuildContext context, int itemIndex, int pageViewIndex) =>
              //           Container(
              //     child: Text(itemIndex.toString()),
              //     decoration: BoxDecoration(
              //       color: Colors.amber,
              //     ),
              //   ),
              //   options: CarouselOptions(
              //     height: 400,
              //     aspectRatio: 16 / 9,
              //     viewportFraction: 0.8,
              //     initialPage: 0,
              //     enableInfiniteScroll: true,
              //     reverse: false,
              //     autoPlay: true,
              //     autoPlayInterval: Duration(seconds: 3),
              //     autoPlayAnimationDuration: Duration(milliseconds: 800),
              //     autoPlayCurve: Curves.fastOutSlowIn,
              //     enlargeCenterPage: true,
              //     enlargeFactor: 0.3,
              //     //onPageChanged: callbackFunction,
              //     scrollDirection: Axis.horizontal,
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
