import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/enums.dart';

class EventModel {
  String uid = '';
  String title = '';
  String description = '';
  String geohash = '';
  GeoPoint? geoPoint;
  String type; // Default type
  String address = '';
  Map<String, dynamic>? location; // or a custom Location class
  bool isAddressVisible = true;
  bool isOpenParty = false; // e.g. from the Switch
  bool isPaidEvent = false;
  int maxGuests = 0;
  int currGuests = 0;
  DateTime? date; // or a Timestamp
  int timestamp;
  List<String> music;
  List<String> amenities;
  List<String> foodsDrinks;
  List<String> images; // e.g. list of image URLs
  RequestStatus requestStatus;
  List<String> pendingGuests;
  List<String> acceptedGuest;
  List<String> rejectedGuests;

  EventModel({
    this.uid = '',
    this.title = '',
    this.description = '',
    this.geohash = '',
    this.geoPoint,
    this.location,
    this.address = '',
    this.isAddressVisible = true,
    this.isOpenParty = true,
    this.isPaidEvent = false,
    this.type = 'upcomingEvent',
    this.maxGuests = 0,
    this.currGuests = 0,
    this.date,
    this.timestamp = 0,
    this.requestStatus = RequestStatus.notSent,
    List<String>? music,
    List<String>? pendingGuests,
    List<String>? acceptedGuest,
    List<String>? rejectedGuests,
    List<String>? amenities,
    List<String>? foodsDrinks,
    List<String>? images,
  })  : music = music ?? [],
        amenities = amenities ?? [],
        foodsDrinks = foodsDrinks ?? [],
        images = images ?? [],
        pendingGuests = pendingGuests ?? [],
        acceptedGuest = acceptedGuest ?? [],
        rejectedGuests = rejectedGuests ?? [];

  /// Convert to a Map so we can upload to Firestore easily.
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'title': title,
      'description': description,
      'type': type,
      'geohash': geohash,
      'address': address,
      'geoPoint': geoPoint,
      'location': location,
      'isAddressVisible': isAddressVisible,
      'isOpenParty': isOpenParty,
      'maxGuests': maxGuests,
      'currGuests': currGuests,
      'date': date,
      'timestamp': date != null ? Timestamp.fromDate(date!) : null,
      'music': music,
      'amenities': amenities,
      'foodsDrinks': foodsDrinks,
      'images': images,
      'requestStatus': requestStatus.index,
      'pendingGuests': [],
      'acceptedGuest': [],
      'rejectedGuests': [],
    };
  }

  /// Factory constructor to create an EventModel from a map
  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      uid: map['uid'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      type: map['type'] ?? 'upcomingEvent',
      geohash: map['geohash'] ?? '',
      geoPoint: map['geoPoint'] as GeoPoint?,
      location: map['location'] != null
          ? Map<String, dynamic>.from(map['location'])
          : null,
      address: map['address'] ?? '',
      isAddressVisible: map['isAddressVisible'] ?? true,
      isOpenParty: map['isOpenParty'] ?? true,
      isPaidEvent: map['isPaidEvent'] ?? false,
      maxGuests: map['maxGuests'] ?? 0,
      currGuests: map['currGuests'] ?? 0,
      date:
          map['date'] is Timestamp ? (map['date'] as Timestamp).toDate() : null,
      timestamp: map['timestamp'] is Timestamp
          ? (map['timestamp'] as Timestamp).millisecondsSinceEpoch
          : (map['timestamp'] as int? ?? 0),
      music: map['music'] != null ? List<String>.from(map['music']) : [],
      amenities:
          map['amenities'] != null ? List<String>.from(map['amenities']) : [],
      foodsDrinks: map['foodsDrinks'] != null
          ? List<String>.from(map['foodsDrinks'])
          : [],
      images: map['images'] != null ? List<String>.from(map['images']) : [],
      requestStatus: map['requestStatus'] != null
          ? RequestStatus.values[map['requestStatus']]
          : RequestStatus.notSent,
      pendingGuests: map['pendingGuests'] != null
          ? List<String>.from(map['pendingGuests'])
          : [],
      acceptedGuest: map['acceptedGuest'] != null
          ? List<String>.from(map['acceptedGuest'])
          : [],
      rejectedGuests: map['rejectedGuests'] != null
          ? List<String>.from(map['rejectedGuests'])
          : [],
    );
  }
}
