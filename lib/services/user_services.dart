import 'package:Sharey/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<void> updateUser(User user) async {
    try {
      await _usersCollection.doc(user.id).update(user.toJson());
      print('User updated successfully');
    } catch (e) {
      print('Error updating user: $e');
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

  Stream<QuerySnapshot> getUsers() {
    return _usersCollection.snapshots();
  }
}
