import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sizer/sizer.dart';

class FirestoreChips extends StatefulWidget {
  final List<String> docIds; // IDs we want to display

  const FirestoreChips({
    Key? key,
    required this.docIds,
  }) : super(key: key);

  @override
  _FirestoreChipsState createState() => _FirestoreChipsState();
}

class _FirestoreChipsState extends State<FirestoreChips> {
  final String collectionName = "music";
  late Stream<QuerySnapshot> musicStream;
  late Stream<QuerySnapshot> fnbStream;
  late Stream<QuerySnapshot> amenitiesStream;
  @override
  void initState() {
    super.initState();
    musicStream = FirebaseFirestore.instance.collection("music").snapshots();
    fnbStream =
        FirebaseFirestore.instance.collection("drinks_foods").snapshots();
    amenitiesStream =
        FirebaseFirestore.instance.collection("amenities").snapshots();
  }

  Stream<List<QueryDocumentSnapshot>> combineThreeStreams(
    Stream<QuerySnapshot> stream1,
    Stream<QuerySnapshot> stream2,
    Stream<QuerySnapshot> stream3,
  ) {
    // Convert each QuerySnapshot stream into a stream of Lists of docs.
    final s1 = stream1.map((snapshot) => snapshot.docs);
    final s2 = stream2.map((snapshot) => snapshot.docs);
    final s3 = stream3.map((snapshot) => snapshot.docs);

    return Rx.combineLatest3<
        List<QueryDocumentSnapshot>,
        List<QueryDocumentSnapshot>,
        List<QueryDocumentSnapshot>,
        List<QueryDocumentSnapshot>>(
      s1,
      s2,
      s3,
      (docs1, docs2, docs3) {
        // Merge all docs into a single List
        return docs1 + docs2 + docs3;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<QueryDocumentSnapshot>>(
      stream: combineThreeStreams(musicStream, fnbStream, amenitiesStream),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Text("Error loading items.");
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("No items found.");
        }

        // Get all documents from the snapshot
        final allDocs = snapshot.data!;

        // Filter by only those whose ID is in widget.docIds
        final filteredDocs =
            allDocs.where((doc) => widget.docIds.contains(doc.id)).toList();

        if (filteredDocs.isEmpty) {
          return const Text("No matching IDs found in Firestore.");
        }

        // Build the chips from the filtered documents
        List<Widget> chips = [];
        for (var doc in filteredDocs) {
          final data = doc.data() as Map<String, dynamic>;

          final String label = data['title'] ?? data['Genre'] ?? 'Unknown';
          final String iconName = data['icon'] ?? 'help_outline';

          chips.add(
            Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: Row(
                children: [
                  Icon(mapStringToIconData(iconName),
                      size: 16.sp, color: Colors.black87),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: chips,
        );
      },
    );
  }

  IconData mapStringToIconData(String iconName) {
    switch (iconName) {
      case 'music_note':
        return Icons.music_note;
      case 'queue_music':
        return Icons.queue_music;
      case 'library_music':
        return Icons.library_music;
      case 'audiotrack':
        return Icons.audiotrack;
      case 'music_video':
        return Icons.music_video;
      case 'music_off':
        return Icons.music_off;
      case 'album':
        return Icons.album;
      case 'volume_up':
        return Icons.volume_up;
      case 'speaker':
        return Icons.speaker;
      case 'pool':
        return Icons.pool;
      case 'wifi':
        return Icons.wifi;
      case 'fireplace':
        return Icons.fireplace;
      case 'speaker':
        return Icons.speaker;
      case 'mic':
        return Icons.mic;
      case 'local_bar':
        return Icons.local_bar;
      case 'sports_bar':
        return Icons.sports_bar;
      case 'album':
        return Icons.album;
      case 'highlight':
        return Icons.highlight;
      case 'cloud':
        return Icons.cloud;
      case 'sports_esports':
        return Icons.sports_esports;
      case 'camera':
        return Icons.camera;
      case 'casino':
        return Icons.casino;
      case 'weekend':
        return Icons.weekend;
      case 'outdoor_grill':
        return Icons.outdoor_grill;
      case 'music_note':
        return Icons.music_note;
      case 'present_to_all':
        return Icons.present_to_all;
      case 'flare':
        return Icons.flare;
      case 'cabin':
        return Icons.cabin;
      case 'star':
        return Icons.star;
      case 'security':
        return Icons.security;
      case 'directions_car':
        return Icons.directions_car;
      case 'checkroom':
        return Icons.checkroom;
      case 'wc':
        return Icons.wc;
      case 'photo_camera':
        return Icons.photo_camera;
      case 'assistant_photo':
        return Icons.assistant_photo;
      case 'local_florist':
        return Icons.local_florist;
      case 'celebration':
        return Icons.celebration;
      case 'bakery_dining':
        return Icons.bakery_dining;
      case 'emoji_food_beverage':
        return Icons.emoji_food_beverage;
      case 'local_drink':
        return Icons.local_drink;
      case 'wine_bar':
        return Icons.wine_bar;
      case 'medical_services':
        return Icons.medical_services;
      case 'restaurant':
        return Icons.restaurant;
      case 'restaurant_menu':
        return Icons.restaurant_menu;
      case 'local_movies':
        return Icons.local_movies;
      case 'local_cafe':
        return Icons.local_cafe;
      case 'smoking_rooms':
        return Icons.smoking_rooms;
      case 'headphones':
        return Icons.headphones;
      case 'waves':
        return Icons.waves;
      case 'wb_incandescent':
        return Icons.wb_incandescent;
      case 'child_care':
        return Icons.child_care;
      case 'brush':
        return Icons.brush;
      case 'light_mode':
        return Icons.light_mode;
      case 'emoji_objects':
        return Icons.emoji_objects;
      case 'wb_sunny':
        return Icons.wb_sunny;
      case 'whatshot':
        return Icons.whatshot;
      case 'slideshow':
        return Icons.slideshow;
      case 'ac_unit':
        return Icons.ac_unit;
      case 'theaters':
        return Icons.theaters;
      case 'timer':
        return Icons.timer;
      case 'local_bar':
        return Icons.local_bar;
      case 'wine_bar':
        return Icons.wine_bar;
      case 'fastfood':
        return Icons.fastfood;
      case 'local_pizza':
        return Icons.local_pizza;
      case 'takeout_dining':
        return Icons.takeout_dining;
      case 'lunch_dining':
        return Icons.lunch_dining;
      case 'dinner_dining':
        return Icons.dinner_dining;
      case 'ramen_dining':
        return Icons.ramen_dining;
      case 'free_breakfast':
        return Icons.free_breakfast;
      case 'bakery_dining':
        return Icons.bakery_dining;
      case 'icecream':
        return Icons.icecream;
      default:
        return Icons.help_outline; // fallback icon
    }
  }
}
