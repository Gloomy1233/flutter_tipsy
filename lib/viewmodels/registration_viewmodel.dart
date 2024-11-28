import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class RegistrationViewModel extends ChangeNotifier {
  // Fields
  bool isGuest = false;
  String fullName = '';
  String email = '';
  String password = '';
  String repeatPassword = '';
  String phone = '';
  bool isPhoneVisible = false;
  String dateOfBirth = '';
  int timestampOfBirth = 0;
  int sex = 0;
  int relationshipStatus = 0;
  String bio = '';
  String? profilePictureUri;
  File? profilePicture;

  // Setters
  void setAccountType(bool value) {
    isGuest = value;
    notifyListeners();
  }

  void setFullName(String value) {
    fullName = value;
    notifyListeners();
  }

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  void setRepeatPassword(String value) {
    repeatPassword = value;
    notifyListeners();
  }

  void setPhone(String value) {
    phone = value;
    notifyListeners();
  }

  void setSex(int value) {
    sex = value;
    notifyListeners();
  }

  void setRelationshipStatus(int value) {
    relationshipStatus = value;
    notifyListeners();
  }

  void setDate(int timestamp, String date) {
    timestampOfBirth = timestamp;
    dateOfBirth = date;
    notifyListeners();
  }

  void setProfilePicture(File? file) {
    profilePicture = file;
    notifyListeners();
  }

  // Add similar setters for other fields...

  // Validation
  bool isNextEnabled(int currentPage) {
    switch (currentPage) {
      case 0:
        return isGuest != null;
      case 1:
        return true;
      // return fullName.isNotEmpty &&
      //     email.isNotEmpty &&
      //     isValidEmail(email) &&
      //     password == repeatPassword &&
      //     password.length >= 6 &&
      //     phone.isNotEmpty;
      case 2:
        return dateOfBirth.isNotEmpty;
      case 3:
        return true;
      default:
        return false;
    }
  }

  bool isValidEmail(String email) {
    String pattern = r'^[^@\s]+@[^@\s]+\.[^@\s]+$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  void notify() {
    notifyListeners();
  }

  Future<void> saveRegistrationDataToFirebase() async {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final storage = FirebaseStorage.instance;
    print("email: ${email}password: ${password}");
    try {
      // 1. Create user with email and password
      UserCredential authResult = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String uid = authResult.user?.uid ?? '';

      // Upload image to Firebase Storage and get its URL
      String? imageUrl = await _uploadImageToFirebase(uid);

      // Save user data including image URL to Firestore
      await _saveUserDataToFirestore(uid, imageUrl);

      // Navigate to the main screen or login page after successful signup
      //Navigator.pushReplacementNamed(context, '/login');

      // 2. Upload profile picture if available
      // 4. Save user data to Firestore
      //await firestore.collection('users').doc(uid).set(userData);

      print('User registered successfully with UID: $uid');
    } catch (e) {
      print('Error during registration: ${e.toString()}');
      throw e;
    }
  }
  // Save to Firebase

  Future<String?> _uploadImageToFirebase(String uid) async {
    if (profilePicture == null) return null;

    try {
      // Reference to the profile location in Firebase Storage
      final storageRef =
          FirebaseStorage.instance.ref().child('user_images').child('$uid.jpg');

      // Upload the image and await for the task to complete
      await storageRef.putFile(profilePicture!);

      // Get and return the download URL
      String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');

      return null;
    }
  }

  Future<void> _saveUserDataToFirestore(String uid, String? imageUrl) async {
    Map<String, dynamic> userData = {
      'uid': uid,
      'accountType': isGuest,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'isPhoneVisible': isPhoneVisible,
      'dateOfBirth': dateOfBirth,
      'sex': sex,
      'relationshipStatus': relationshipStatus,
      'bio': bio,
      'profilePictureUrl': imageUrl,
    };

    await FirebaseFirestore.instance.collection('users').doc(uid).set(userData);
  }
}
