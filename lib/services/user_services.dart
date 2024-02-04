import 'package:Sharey/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<User?> getUser(String userId) async {
    try {
      DocumentSnapshot snapshot = await _usersCollection.doc(userId).get();
      if (snapshot.exists) {
        User? user = User.fromJson(snapshot.data() as Map<String, dynamic>);
        return user;
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<void> addUser(User user) async {
    try {
      await _usersCollection.doc(user.id).set(user.toJson());
      print('User added successfully');
    } catch (e) {
      print('Error adding user i n addUser: $e');
    }
  }

  Future<bool> updateUser(User user) async {
    try {
      await _usersCollection.doc(user.id).update(user.toJson());
      Fluttertoast.showToast(
        msg: 'User updated successfully',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return true;
    } catch (e) {
      print('Error updating user: $e');
      Fluttertoast.showToast(
        msg: 'User updated failed with error: $e',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _usersCollection.doc(userId).delete();
      print('User deleted successfully');
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  Future<List<User>> getUsers() {
    return _usersCollection.get().then((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => User.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<List<User>> searchUsers(String query) async {
    try {
      List<User> users = [];
      var res = await _usersCollection
          .where('firstName', isGreaterThanOrEqualTo: query)
          .get();

      for (var doc in res.docs) {
        users.add(User.fromJson(doc.data() as Map<String, dynamic>));
      }
      return users;
    } catch (e) {
      print('Error searching users: $e');
      return [];
    }
  }
}
