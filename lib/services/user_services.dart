import 'package:Sharey/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUser(User user) async {
    try {
      await _usersCollection.doc(user.id).set(
            user.toJson(),
            // Add other user-related data as needed
          );
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
