import 'package:Sharey/constants.dart';
import 'package:Sharey/screens/create_content/create_content.dart';
import 'package:flutter/material.dart';

class EmptyStatus extends StatelessWidget {
  const EmptyStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Image.asset("assets/images/lets_teach_something.png",
              height: 200, width: 200),
          const Text(
            "You don't have any lessons yet \n Start teaching  \n and earn coupons!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 20,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            constraints: const BoxConstraints(
              maxWidth: 150, // Set your maximum width
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, CreateContentScreen.routeName);
              },
              child: const Text("Start Teaching"),
            ),
          )
        ],
      ),
    );
  }
}
