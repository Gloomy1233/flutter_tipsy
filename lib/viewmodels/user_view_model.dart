import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tipsy/viewmodels/user_model.dart';

class UserViewModel extends ChangeNotifier {
  UserDataModel? userDataModel;

  Future<void> fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String uid = currentUser.uid;

      try {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          userDataModel = UserDataModel(
            accountType: userData['accountType'] ?? false,
            bio: userData['bio'] ?? '',
            dateOfBirth: userData['dateOfBirth'] ?? '',
            email: userData['email'] ?? '',
            fullName: userData['fullName'] ?? '',
            isPhoneVisible: userData['isPhoneVisible'] ?? false,
            phone: userData['phone'] ?? '',
            profilePictureUrl: userData['profilePictureUrl'],
            relationshipStatus: userData['relationshipStatus'] ?? 0,
            sex: userData['sex'] ?? 0,
            uid: userData['uid'] ?? '',
          );

          notifyListeners(); // Notify listeners to update UI
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }
}
