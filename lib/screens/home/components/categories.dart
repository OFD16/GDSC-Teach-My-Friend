import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class Categories extends StatefulWidget {
  int selected;
  final ValueChanged<int>? onTabChanged;

  Categories({
    Key? key,
    required this.selected,
    this.onTabChanged,
  }) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {"icon": "assets/icons/sports.svg", "text": "Sports", "tab": 0},
      {
        "icon": "assets/icons/education.svg",
        "text": "School \n Lessons",
        "tab": 1
      },
      {"icon": "assets/icons/art.svg", "text": "Art", "tab": 2},
      {"icon": "assets/icons/instrument.svg", "text": "Music", "tab": 3},
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
            press: () {
              setState(() {
                widget.selected = categories[index]["tab"];
                if (widget.onTabChanged != null) {
                  widget.onTabChanged!(categories[index]["tab"]);
                }
              });
            },
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
  final GestureTapCallback press;

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
            child: SvgPicture.asset(
              icon,
              color: kPrimaryColor,
              width: 48,
              height: 48,
            ),
          ),
          const SizedBox(height: 4),
          Text(text, textAlign: TextAlign.center)
        ],
      ),
    );
  }
}
