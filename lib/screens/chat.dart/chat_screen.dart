import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  static String routeName = "/chat";
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Chat Screen",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text("Chat with your friends \n and learn together!"),
            Image(
              image: AssetImage('assets/images/chat_image.png'),
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
