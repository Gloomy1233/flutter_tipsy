import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'event_model.dart';

class CreateEventViewModel extends ChangeNotifier {
  // Event Fields

  /// This holds all data about our party
  EventModel _partyData = EventModel();

  // 2) Create a getter (no parentheses) to expose _partyData:
  EventModel get partyData => _partyData;

  /// Example of setting fields
  set uid(String value) {
    _partyData.uid = value;
    notifyListeners();
  }

  set title(String value) {
    _partyData.title = value;
    notifyListeners();
  }

  set description(String value) {
    _partyData.description = value;
    notifyListeners();
  }

  set geohash(String value) {
    _partyData.geohash = value;
    notifyListeners();
  }

  set geoPoint(GeoPoint? value) {
    _partyData.geoPoint = value;
    notifyListeners();
  }

  set address(String value) {
    _partyData.address = value;
    notifyListeners();
  }

  set location(Map<String, dynamic> value) {
    _partyData.location = value;
    notifyListeners();
  }

  set isAddressVisible(bool value) {
    _partyData.isAddressVisible = value;
    notifyListeners();
  }

  bool get isOpenParty => _partyData.isOpenParty;

  set isOpenParty(bool value) {
    _partyData.isOpenParty = value;
    notifyListeners();
  }

  set maxGuests(int value) {
    _partyData.maxGuests = value;
    notifyListeners();
  }

  set currGuests(int value) {
    _partyData.currGuests = value;
    notifyListeners();
  }

  set date(DateTime? value) {
    _partyData.date = value;
    notifyListeners();
  }

  set isPaidEvent(bool value) {
    _partyData.isPaidEvent = value;
    notifyListeners();
  }

  /// For lists, you can directly manipulate them or set them at once
  set music(List<String> value) {
    _partyData.music = value;
    notifyListeners();
  }

  set amenities(List<String> value) {
    _partyData.amenities = value;
    notifyListeners();
  }

  set foodsDrinks(List<String> value) {
    _partyData.foodsDrinks = value;
    notifyListeners();
  }

  set images(List<String> value) {
    _partyData.images = value;
    notifyListeners();
  }

  set acceptedGuests(List<String> value) {
    _partyData.acceptedGuests = value;
    notifyListeners();
  }

  set rejectedGuests(List<String> value) {
    _partyData.rejectedGuests = value;
    notifyListeners();
  }

  set pendingGuests(List<String> value) {
    _partyData.pendingGuests = value;
    notifyListeners();
  }

  /// Example method: Adds a single image URL to the existing list
  void addImage(String url) {
    _partyData.images.add(url);
    notifyListeners();
  }

  /// Finally: a method to save to Firestore
  Future<void> savePartyToFirestore() async {
    try {
      final eventRef = FirebaseFirestore.instance
          .collection('events')
          .doc(); // Generate a new doc ID
      _partyData.id =
          eventRef.id; // Store Firestore-generated ID inside the event

      await eventRef.set(_partyData.toMap()); // Save event to Firestore

      print("Event saved successfully with ID: ${_partyData.id}");

      // Clear or reset data after saving
      _partyData = EventModel();
      notifyListeners();
    } catch (e) {
      debugPrint("Error saving to Firestore: $e");
      rethrow;
    }
  }

  void setIsPaidEvent(bool value) {
    isPaidEvent = value;
    notifyListeners();
  }

  // Updated isNextEnabled method
  bool isNextEnabled(int currentPage) {
    switch (currentPage) {
      case 0:
        // Title must be at least 5 characters and description at least 50 characters
        // If it's not an open party, maxGuests must be at least 10
        return partyData.title.length >= 5 &&
            partyData.description.length >= 100 &&
            (partyData.date != null);
      case 1:
        // Location must be set, and isAddressVisible must be true or false
        return partyData.location!.isNotEmpty &&
            (partyData.isAddressVisible == true ||
                partyData.isAddressVisible == false);
      case 2:
        return true;
      case 3:
        // Optional validation, so it always passes
        return partyData.images.isNotEmpty;
      case 4:
        // At least one photo is required
        return true;
      default:
        return false;
    }
  }

  // Validation Method
  bool isFormValid() {
    return partyData.title.isNotEmpty &&
        partyData.description.isNotEmpty &&
        partyData.date != null &&
        partyData.geoPoint != null;
  }

  void notify() {
    notifyListeners();
  }
}
