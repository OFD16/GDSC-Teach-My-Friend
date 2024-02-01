import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class Categories extends StatefulWidget {
  int selected;
  void Function()? press;
  Categories({super.key, this.selected = 0, this.press});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {"icon": "assets/icons/Flash Icon.svg", "text": "Sports", "tab": 0},
      {
        "icon": "assets/icons/Bill Icon.svg",
        "text": "School \n Lessons",
        "tab": 1
      },
      {"icon": "assets/icons/Game Icon.svg", "text": "Game", "tab": 2},
      {"icon": "assets/icons/Gift Icon.svg", "text": "Music", "tab": 3},
      {"icon": "assets/icons/Discover.svg", "text": "More", "tab": 4},
    ];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          categories.length,
          (index) => CategoryCard(
            tab: categories[index]["tab"],
            icon: categories[index]["icon"],
            text: categories[index]["text"],
            selected: widget.selected,
            press: widget.press,
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.selected,
    required this.tab,
    required this.press,
  }) : super(key: key);

  final String icon, text;
  final int selected, tab;
  final GestureTapCallback? press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: selected == tab ? kPurpleColor : kPrimaryLightColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(icon),
          ),
          const SizedBox(height: 4),
          Text(text, textAlign: TextAlign.center)
        ],
      ),
    );
  }
}
