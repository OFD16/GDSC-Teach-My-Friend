import 'package:Sharey/constants.dart';
import 'package:Sharey/screens/create_content/create_content.dart';
import 'package:flutter/material.dart';

class EmptyStatus extends StatelessWidget {
  const EmptyStatus(
      {super.key, required this.isAuthUser, required this.tabName});
  final String tabName;
  final bool isAuthUser;
  @override
  Widget build(BuildContext context) {
    print("isAuthUser : $isAuthUser");
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Image.asset("assets/images/lets_teach_something.png",
              height: 200, width: 200),
          Text(
            isAuthUser
                ? "You don't have any ${tabName == "Lessons" ? "lessons" : "coupons"} yet \n Start teaching  \n and earn coupons!"
                : "This user doesn't have\n any ${tabName == "Lessons" ? "lessons" : "coupons"}  yet",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: kPrimaryColor,
              fontSize: 20,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            constraints: const BoxConstraints(
              maxWidth: 150, // Set your maximum width
            ),
            child: isAuthUser
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, CreateContentScreen.routeName);
                    },
                    child: const Text("Start Teaching"),
                  )
                : const SizedBox(),
          )
        ],
      ),
    );
  }
}
