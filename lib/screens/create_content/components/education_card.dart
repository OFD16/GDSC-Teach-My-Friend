import 'package:flutter/material.dart';

import "./stroke_text.dart";

class EducationCard extends StatelessWidget {
  final Map<String, dynamic> education;
  void Function()? onTap;

  EducationCard({super.key, required this.education, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(education["image"]!),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: StrokeText(
          education["title"]!,
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          strokeColor: Colors.black,
          strokeWidth: 1.2,
        ),
      ),
    );
  }
}
