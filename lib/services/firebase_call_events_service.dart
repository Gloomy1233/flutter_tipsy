import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Save user's location with geohash
  Future<void> saveUserLocation(
      String uid, double latitude, double longitude) async {
    final GeoFirePoint location = GeoFirePoint(GeoPoint(latitude, longitude));
    print("sadsadsadsadsa21312312");
    await _firestore.collection('events').doc(uid).set(
      {
        'location': location.data, // GeoFirePoint generates geohash + GeoPoint
        'uid': uid,
      },
      SetOptions(merge: true), // Ensure existing data isn't overwritten
    );
  }

  /// Get events in a radius as a stream
  Stream<List<GeoDocumentSnapshot<Map<String, dynamic>>>> getEventsInRadius(
      double latitude, double longitude, double radiusInKm) {
    final GeoFirePoint center = GeoFirePoint(GeoPoint(37.7749, 122.4194));

    final GeoCollectionReference<Map<String, dynamic>> geoCollection =
        GeoCollectionReference<Map<String, dynamic>>(
            _firestore.collection('events'));
    print("sadsadsadsadsa");
    return geoCollection.subscribeWithinWithDistance(
      center: center, // Center point
      radiusInKm: 100000000, // Radius in kilometers
      field: 'location', // Firestore field where GeoFirePoint is stored
      geopointFrom: (data) => GeoPoint(
        (data['location']['geopoint'] as GeoPoint).latitude,
        (data['location']['geopoint'] as GeoPoint).longitude,
      ),
      strictMode: true, // Only return events strictly within the radius
      asBroadcastStream: true, // Broadcast stream for multiple listeners
    );
  }
}

class GeoLocationService {
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return null;
    }

    // Check for permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permissions are denied.");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permissions are permanently denied.");
      return null;
    }

    // Get current position
    return await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.best));
  }
}
