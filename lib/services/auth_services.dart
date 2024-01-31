import 'package:Sharey/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/User.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  UserService userService = UserService();

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      firebase_auth.UserCredential result = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      Fluttertoast.showToast(
        msg: 'User logged in successfully',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      User tempUser = User(
        id: result.user!.uid,
        email: email,
        password: password,
        createdAt: result.user?.metadata.creationTime,
        lastSignInTime: result.user?.metadata.lastSignInTime,
        phoneNumber: result.user?.phoneNumber,
        isEmailVerified: result.user?.emailVerified,
        photoUrl: result.user?.photoURL,
        firstName: result.user?.displayName,
      );

      // print(" temp user vcalue : value of user: ${tempUser.toJson()}");

      User? cloudUser = await userService.getUser(result.user!.uid);

      // print("cloud user value : value of user: ${cloudUser?.toJson()}");
      tempUser = cloudUser ?? tempUser;
      return tempUser;
    } on firebase_auth.FirebaseException catch (e) {
      String errorMessage = '';
      if (e.message ==
          'The supplied auth credential is incorrect, malformed or has expired.') {
        errorMessage = 'Invalid email, password or unregistered user';
      } else {
        errorMessage = e.message!;
      }
      Fluttertoast.showToast(
        msg: errorMessage,
        gravity: ToastGravity.TOP,
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
      firebase_auth.UserCredential result = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User tempUser = User(
        id: result.user!.uid,
        email: email,
        password: password,
        createdAt: result.user?.metadata.creationTime,
        lastSignInTime: result.user?.metadata.lastSignInTime,
        phoneNumber: result.user?.phoneNumber,
        isEmailVerified: result.user?.emailVerified,
        photoUrl: result.user?.photoURL,
        firstName: result.user?.displayName,
      );
      // Create a new user in firestore

      await userService.addUser(tempUser);
      Fluttertoast.showToast(
        msg: 'User registered successfully',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return tempUser;
    } on firebase_auth.FirebaseException catch (e) {
      Fluttertoast.showToast(
        msg: e.message!,
        gravity: ToastGravity.TOP,
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
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } on firebase_auth.FirebaseException catch (e) {
      print('-----------------------error-------------------------');
      print(e);
      Fluttertoast.showToast(
        msg: e.message!,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  // Update user data , firstName + lastName = displayName, phoneNumber, address
// Update user data
  // Future<void> updateUserData(String userId, String firstName, String lastName,
  //     String phoneNumber, String address) async {
  //   try {
  //     await FirebaseFirestore.instance.collection('users').doc(userId).update({
  //       'firstName': firstName,
  //       'lastName': lastName,
  //       'phoneNumber': phoneNumber,
  //       'address': address,
  //     });
  //     Fluttertoast.showToast(
  //       msg: 'User data updated successfully',
  //       gravity: ToastGravity.TOP,
  //       backgroundColor: Colors.greenAccent,
  //       textColor: Colors.white,
  //       fontSize: 16.0,
  //     );
  //   } on FirebaseException catch (e) {
  //     Fluttertoast.showToast(
  //       msg: e.message!,
  //       gravity: ToastGravity.TOP,
  //       backgroundColor: Colors.redAccent,
  //       textColor: Colors.white,
  //       fontSize: 16.0,
  //     );
  //   }
  // }

  // final userCollection = FirebaseFirestore.instance.collection('users');

  // Future<QuerySnapshot> registerUser(String email, String password) async {
  //   // Check if the user with the given email already exists
  //   QuerySnapshot existingUsers =
  //       await userCollection.where('email', isEqualTo: email).get();

  //   if (existingUsers.docs.isNotEmpty) {
  //     // User with the same email already exists
  //     Fluttertoast.showToast(
  //       msg: "User with this email already exists",
  //       gravity: ToastGravity.TOP,
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
  //       gravity: ToastGravity.TOP,
  //       backgroundColor: Colors.greenAccent,
  //       textColor: Colors.white,
  //       fontSize: 16.0,
  //     );
  //     return 200;

  //   }).catchError((error) {
  //     print("Failed to add user: $error");
  //     Fluttertoast.showToast(
  //       msg: "Failed to add user: $error",
  //       gravity: ToastGravity.TOP,
  //       backgroundColor: Colors.redAccent,
  //       textColor: Colors.white,
  //       fontSize: 16.0,
  //     );
  //     return 404;
  //   });

  //   return 404;
  // }
}
