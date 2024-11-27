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
  int sex = 0;
  int relationshipStatus = 0;
  String bio = '';
  String? profilePictureUri;

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

  // Save to Firebase
  Future<void> saveRegistrationDataToFirebase() async {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final storage = FirebaseStorage.instance;

    try {
      // 1. Create user with email and password
      UserCredential authResult = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String uid = authResult.user?.uid ?? '';

      // 2. Upload profile picture if available
      String? profilePictureUrl;
      if (profilePictureUri != null && profilePictureUri!.isNotEmpty) {
        Reference storageRef = storage.ref().child('profile_pictures/$uid.jpg');
        UploadTask uploadTask = storageRef.putFile(File(profilePictureUri!));
        await uploadTask;
        profilePictureUrl = await storageRef.getDownloadURL();
      }

      // 3. Create user data object
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
        'profilePictureUrl': profilePictureUrl,
      };

      // 4. Save user data to Firestore
      await firestore.collection('users').doc(uid).set(userData);

      print('User registered successfully with UID: $uid');
    } catch (e) {
      print('Error during registration: ${e.toString()}');
      throw e;
    }
  }
}
