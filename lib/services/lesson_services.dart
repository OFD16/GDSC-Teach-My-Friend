import 'package:Sharey/models/Lesson.dart';
import 'package:Sharey/services/user_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LessonService {
  UserService userService = UserService();
  final CollectionReference _lessonsCollection =
      FirebaseFirestore.instance.collection('lessons');

  Future<Lesson?> getLesson(String lessonId) async {
    try {
      final doc = await _lessonsCollection.doc(lessonId).get();
      if (doc.exists) {
        return Lesson.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        print('Lesson not found');
        // Fluttertoast.showToast(
        //   msg: 'Lesson not found',
        //   gravity: ToastGravity.TOP,
        //   backgroundColor: Colors.redAccent,
        //   textColor: Colors.white,
        //   fontSize: 16.0,
        // );
        return null;
      }
    } catch (e) {
      print('Error getting coupon: $e');
      return null;
    }
  }

  Future<Lesson?> createLesson(Lesson lesson) async {
    try {
      // Create a document reference
      DocumentReference<Object?> documentReference =
          await _lessonsCollection.add(lesson.toJson());

      // Get the data from the document reference
      DocumentSnapshot<Object?> documentSnapshot =
          await documentReference.get();

      // Access the data using documentSnapshot.data()
      Object? data = documentSnapshot.data();
      Lesson createdLesson = Lesson.fromJson(data as Map<String, dynamic>);
      createdLesson.id = documentReference.id;

      // Update the document with the ID
      await updateLesson(documentReference.id, createdLesson);

      return createdLesson;
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error creating lesson',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return null;
    }
  }

  Future<void> updateLesson(String? lessonId, Lesson updatedLesson) async {
    try {
      await _lessonsCollection.doc(lessonId).update(updatedLesson.toJson());
      Fluttertoast.showToast(
        msg: 'Lesson updated successfully',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error updating lesson',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> deleteLesson(String lessonId) async {
    try {
      await _lessonsCollection.doc(lessonId).delete();
      Fluttertoast.showToast(
        msg: 'Lesson deleted successfully',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error deleting lesson',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<List<Lesson>> getUserLessons(String userId) async {
    try {
      final doc =
          await _lessonsCollection.where('ownerId', isEqualTo: userId).get();
      if (doc.docs.isNotEmpty) {
        return doc.docs
            .map((doc) => Lesson.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      } else {
        // Fluttertoast.showToast(
        //   msg: 'Lesson not found',
        //   gravity: ToastGravity.TOP,
        //   backgroundColor: Colors.redAccent,
        //   textColor: Colors.white,
        //   fontSize: 16.0,
        // );
        return [];
      }
    } catch (e) {
      print('Error getting coupon: $e');
      Fluttertoast.showToast(
        msg: 'Error occured when trying to get lessons: $e',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return [];
    }
  }

  Future<List<Lesson>> getLessons() async {
    try {
      final doc = await _lessonsCollection.get();
      if (doc.docs.isNotEmpty) {
        return doc.docs
            .map((doc) => Lesson.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      } else {
        // Fluttertoast.showToast(
        //   msg: 'Lesson not found',
        //   gravity: ToastGravity.TOP,
        //   backgroundColor: Colors.redAccent,
        //   textColor: Colors.white,
        //   fontSize: 16.0,
        // );
        return [];
      }
    } catch (e) {
      print('Error getting coupon: $e');
      Fluttertoast.showToast(
        msg: 'Error occured when trying to get lessons: $e',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return [];
    }
  }

  Future<List<Lesson>> getFavouriteLessons(List<String> favouriteIds) async {
    try {
      // Check if favouriteIds is not empty
      if (favouriteIds.isNotEmpty) {
        final doc =
            await _lessonsCollection.where('id', whereIn: favouriteIds).get();

        if (doc.docs.isNotEmpty) {
          return doc.docs
              .map((doc) => Lesson.fromJson(doc.data() as Map<String, dynamic>))
              .toList();
        } else {
          // Handle the case where no lessons are found
          Fluttertoast.showToast(
            msg: 'Lesson not found',
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return [];
        }
      } else {
        // Handle the case where favouriteIds is empty
        Fluttertoast.showToast(
          msg: 'No favourite lessons found',
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return [];
      }
    } catch (e) {
      print('Error getting favourite lessons: $e');
      Fluttertoast.showToast(
        msg: 'Error occurred when trying to get favourite lessons: $e',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return [];
    }
  }

  Future<void> likeLesson(String lessonId, String userId) async {
    try {
      await _lessonsCollection.doc(lessonId).update({
        'likes': FieldValue.arrayUnion([userId])
      });
      await userService.addUserFavorite(userId, lessonId);
      Fluttertoast.showToast(
        msg: 'Lesson liked successfully',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error liking lesson',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> unlikeLesson(String lessonId, String userId) async {
    try {
      await _lessonsCollection.doc(lessonId).update({
        'likes': FieldValue.arrayRemove([userId])
      });
      await userService.removeUserFavorite(userId, lessonId);
      Fluttertoast.showToast(
        msg: 'Lesson unliked successfully',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error unliking lesson',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<List<Lesson>> getUserJoinedLessons(String userId) {
    return _lessonsCollection
        .where('students', arrayContains: userId)
        .get()
        .then((value) => value.docs
            .map((e) => Lesson.fromJson(e.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> leaveLesson(String lessonId, String userId) async {
    try {
      await _lessonsCollection.doc(lessonId).update({
        'students': FieldValue.arrayRemove([userId])
      });
      Fluttertoast.showToast(
        msg: 'Left lesson successfully',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error leaving lesson',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
