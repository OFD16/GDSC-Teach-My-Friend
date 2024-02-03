import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CloudStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadFile(
      File file, String fileName, String storageType) async {
    try {
      final Reference storageRef = _storage.ref(storageType).child(fileName);
      final UploadTask uploadTask = storageRef.putFile(
          file,
          SettableMetadata(
            contentType: "image/jpeg",
          ));
      final TaskSnapshot taskSnapshot =
          await uploadTask.whenComplete(() => null);
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading file: $e');

      Fluttertoast.showToast(
        msg: 'Error uploading file: $e',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return null;
    }
  }

  Future<void> deleteFile(String fileName, String storageType) async {
    try {
      final Reference storageRef = _storage.ref(storageType).child(fileName);
      await storageRef.delete();
    } catch (e) {
      print('Error deleting file: $e');
      Fluttertoast.showToast(
        msg: 'Error deleting file: $e',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
