import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CreateEventViewModel extends ChangeNotifier {
  // Event Fields
  String title = '';
  String type = 'upcomingEvent'; // Default type
  String address = '';
  String description = '';
  int numPeople = 50; // Default value
  int attendingPeople = 0; // Default value
  bool isOpen = false;
  bool isAddressVisible = false; // Default value
  bool isPaidEvent = false; // Default value
  String host = '';
  String geohash = '';
  GeoPoint? geopoint;
  DateTime? date;
  int? timestamp;

  // Photos
  List<File> photoFiles = []; // Local photo files
  List<String> photoUrls = []; // Firebase Storage URLs of uploaded photos

  // Setters
  void setTitle(String value) {
    title = value;
    notifyListeners();
  }

  void setType(String value) {
    type = value;
    notifyListeners();
  }

  void setAddress(String value) {
    address = value;
    notifyListeners();
  }

  void setDescription(String value) {
    description = value;
    notifyListeners();
  }

  void setNumPeople(int value) {
    numPeople = value;
    notifyListeners();
  }

  void setAttendingPeople(int value) {
    attendingPeople = value;
    notifyListeners();
  }

  void setHost(String value) {
    host = value;
    notifyListeners();
  }

  void setGeohash(String value) {
    geohash = value;
    notifyListeners();
  }

  void setGeopoint(double latitude, double longitude) {
    geopoint = GeoPoint(latitude, longitude);
    notifyListeners();
  }

  void setDate(DateTime eventDate) {
    date = eventDate;
    timestamp = eventDate.millisecondsSinceEpoch;
    notifyListeners();
  }

  void addPhoto(File photo) {
    photoFiles.add(photo);
    notifyListeners();
  }

  void removePhoto(int index) {
    if (index >= 0 && index < photoFiles.length) {
      photoFiles.removeAt(index);
      notifyListeners();
    }
  }
  void setIsOpen(bool value) {
    isOpen = value;
    notifyListeners();
  }

  void setIsAddressVisible(bool value) {
    isAddressVisible = value;
    notifyListeners();
  }

  void setIsPaidEvent(bool value) {
    isPaidEvent = value;
    notifyListeners();
  }

  // Validation
  bool isNextEnabled(int currentPage) {
    switch (currentPage) {
      case 0:
        return true;
      case 1:
        return true;
      // return fullName.isNotEmpty &&
      //     email.isNotEmpty &&
      //     isValidEmail(email) &&
      //     password == repeatPassword &&
      //     password.length >= 6 &&
      //     phone.isNotEmpty;
      case 2:
        return true;
      case 3:
        return true;
      default:
        return false;
    }
  }

  // Firebase Methods
  Future<void> saveEventToFirebase() async {
    try {
      // Upload all photos to Firebase Storage and get their URLs
      photoUrls = await _uploadEventPhotos();

      // Save event data to Firestore
      await saveEventDataToFirestore();

      print("Event created successfully");
    } catch (e) {
      print("Error creating event: $e");
      throw e;
    }
  }

  // Helper to upload all photos to Firebase Storage
  Future<List<String>> _uploadEventPhotos() async {
    List<String> uploadedPhotoUrls = [];
    try {
      for (var photo in photoFiles) {
        String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('event_photos')
            .child('$uniqueId.jpg');

        // Upload the photo file
        await storageRef.putFile(photo);

        // Get the photo's download URL
        String downloadUrl = await storageRef.getDownloadURL();
        uploadedPhotoUrls.add(downloadUrl);
      }
    } catch (e) {
      print("Error uploading photos: $e");
      rethrow;
    }
    return uploadedPhotoUrls;
  }

  // Helper to save event data to Firestore
  Future<void> saveEventDataToFirestore() async {
    final firestore = FirebaseFirestore.instance;

    Map<String, dynamic> eventData = {
      'title': title,
      'type': type,
      'address': address,
      'description': description,
      'numPeople': numPeople,
      'attendingPeople': attendingPeople,
      'host': host,
      'geohash': geohash,
      'geopoint': geopoint,
      'photos': photoUrls, // List of photo URLs
      'date': date?.toIso8601String(),
      'timestamp': timestamp,
    };

    await firestore.collection('events').add(eventData);
  }

  // Validation Method
  bool isFormValid() {
    return title.isNotEmpty &&
        address.isNotEmpty &&
        description.isNotEmpty &&
        date != null &&
        geopoint != null;
  }

  void notify() {
    notifyListeners();
  }
}
