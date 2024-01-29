import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      Fluttertoast.showToast(
        msg: 'User logged in successfully',
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return result.user!;
    } on FirebaseException catch (e) {
      String errorMessage = '';
      if (e.message ==
          'The supplied auth credential is incorrect, malformed or has expired.') {
        errorMessage = 'Invalid email, password or unregistered user';
      } else {
        errorMessage = e.message!;
      }
      Fluttertoast.showToast(
        msg: errorMessage,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return null;
    }
  }

  // Register with email and password
  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Fluttertoast.showToast(
        msg: 'User registered successfully',
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return result.user;
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(
        msg: e.message!,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Fluttertoast.showToast(
        msg: 'User logged out successfully',
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } on FirebaseException catch (e) {
      print('-----------------------error-------------------------');
      print(e);
      Fluttertoast.showToast(
        msg: e.message!,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  // final userCollection = FirebaseFirestore.instance.collection('users');

  // Future<QuerySnapshot> registerUser(String email, String password) async {
  //   // Check if the user with the given email already exists
  //   QuerySnapshot existingUsers =
  //       await userCollection.where('email', isEqualTo: email).get();

  //   if (existingUsers.docs.isNotEmpty) {
  //     // User with the same email already exists
  //     Fluttertoast.showToast(
  //       msg: "User with this email already exists",
  //       gravity: ToastGravity.CENTER,
  //       backgroundColor: Colors.redAccent,
  //       textColor: Colors.white,
  //       fontSize: 16.0,
  //     );
  //     return existingUsers;
  //   }

  //   // User with the given email doesn't exist, proceed to add the new user
  //   userCollection.add({
  //     'email': email,
  //     'password': password,
  //   }).then((value) {
  //     print("User Added");

  //     Fluttertoast.showToast(
  //       msg: "User Added",
  //       gravity: ToastGravity.CENTER,
  //       backgroundColor: Colors.greenAccent,
  //       textColor: Colors.white,
  //       fontSize: 16.0,
  //     );
  //     return 200;

  //   }).catchError((error) {
  //     print("Failed to add user: $error");
  //     Fluttertoast.showToast(
  //       msg: "Failed to add user: $error",
  //       gravity: ToastGravity.CENTER,
  //       backgroundColor: Colors.redAccent,
  //       textColor: Colors.white,
  //       fontSize: 16.0,
  //     );
  //     return 404;
  //   });

  //   return 404;
  // }
}
