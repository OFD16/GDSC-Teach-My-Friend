import 'package:flutter/material.dart';

import '../../../components/rounded_icon_btn.dart';
import '../../../constants.dart';
import '../../../models/Lesson.dart';

class ColorDots extends StatelessWidget {
  const ColorDots({
    Key? key,
    required this.lesson,
  }) : super(key: key);

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    int selectedColor = 0;
    List<Color> colors = [Colors.yellow, Colors.blue, Colors.red];
    List<String> levels = ["Beginner", "Intermediate", "Advanced"];
    if (lesson.level == "Beginner") {
      selectedColor = 0;
    } else if (lesson.level == "Intermediate") {
      selectedColor = 1;
    } else if (lesson.level == "Advanced") {
      selectedColor = 2;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Level",
            style: TextStyle(fontSize: 16),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                [1, 2, 3].length,
                (index) => ColorDot(
                  color: colors[index],
                  isSelected: index == selectedColor,
                  text: levels[index],
                ),
              ),
              const Spacer(),

              Text(lesson.level!, style: const TextStyle(fontSize: 16)),
              // RoundedIconBtn(
              //   icon: Icons.remove,
              //   press: () {},
              // ),
              // const SizedBox(width: 20),
              // RoundedIconBtn(
              //   icon: Icons.add,
              //   showShadow: true,
              //   press: () {},
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

class ColorDot extends StatelessWidget {
  const ColorDot({
    Key? key,
    required this.color,
    this.isSelected = false,
    required this.text,
  }) : super(key: key);

  final Color color;
  final bool isSelected;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 2),
          padding: const EdgeInsets.all(8),
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
                color: isSelected ? kPrimaryColor : Colors.transparent),
            shape: BoxShape.circle,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Display each letter of the text vertically
        Text(text.split("")[0], style: const TextStyle(fontSize: 12))
      ],
    );
  }
}
