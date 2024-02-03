import 'package:Sharey/models/Lesson.dart';
import 'package:flutter/material.dart';

class StudentContainer extends StatefulWidget {
  const StudentContainer({super.key, required this.lesson});
  final Lesson lesson;
  @override
  State<StudentContainer> createState() => _StudentContainerState();
}

class _StudentContainerState extends State<StudentContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Text("Students: ${widget.lesson.userLimit}"),
          const Spacer(),
          // IconButton(
          //   icon: const Icon(Icons.add),
          //   onPressed: () {},
          // ),
          widget.lesson.students!.isEmpty
              ? const Text("No students yet")
              : Text("${widget.lesson.students!.length} active students"),
          // Text("${widget.lesson.students!.length} students"),
        ],
      ),
    );
  }
}
