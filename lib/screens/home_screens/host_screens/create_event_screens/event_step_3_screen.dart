import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tipsy/screens/home_screens/widgets_home/search_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../utils/constants.dart';

class EventStep3Screen extends StatefulWidget {
  const EventStep3Screen({super.key});

  @override
  State<EventStep3Screen> createState() => EventStep3ScreenState();
}

class EventStep3ScreenState extends State<EventStep3Screen> {
  bool isAddressVisible = false;
  final TextEditingController dateOfBirthController =
      TextEditingController(text: "adsads");
  final TextEditingController searchController = TextEditingController();

  // List to hold search results
  List<Map<String, dynamic>> searchResults = [];

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to perform search
  Future<void> performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    try {
      // Query Firestore where 'Title' contains the search term
      // Firestore does not support 'contains' directly, so we'll use 'isGreaterThanOrEqualTo' and 'isLessThanOrEqualTo'
      // for simple prefix matching. For more advanced search, consider integrating with Algolia or another search service.

      QuerySnapshot snapshot = await _firestore
          .collection('partyThemes')
          .where('Title', isGreaterThanOrEqualTo: query)
          .where('Title', isLessThanOrEqualTo: query + '\uf8ff')
          .limit(3)
          .get();

      List<Map<String, dynamic>> results = snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      setState(() {
        searchResults = results;
      });
    } catch (e) {
      print("Error performing search: $e");
      // Optionally, handle the error by showing a Snackbar or other UI element
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              children: [
                // Display Search Resultsa
                SizedBox(height: 7.h),

                Text(
                  "Music",
                  style: TextStyle(
                    color: primaryDark,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),

                // Features Tags
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: primaryDarkLighter,
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                    child: Column(
                      children: [
                        SearchWidgetModular(
                          hintText: "Search for Music Genres...",
                          iconResolver: (String iconName) {
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
                              // Add more cases as needed...
                              default:
                                return Icons.music_note; // Fallback icon
                            }
                          },
                          collectionName: 'music',
                          titleFieldName: 'Genre',
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  "Foods & Drinks",
                  style: TextStyle(
                    color: primaryDark,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: primaryDarkLighter,
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                    child: Column(
                      children: [
                        SearchWidgetModular(
                          hintText: "Search for Foods & Drinks...",
                          iconResolver: (String iconName) {
                            switch (iconName) {
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
                                return Icons.fastfood; // fallback
                            }
                          },
                          collectionName: 'drinks_foods',
                          titleFieldName: 'title',
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  "Amenities",
                  style: TextStyle(
                    color: primaryDark,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),

                // Features Tags
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: primaryDarkLighter,
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                    child: Column(
                      children: [
                        SearchWidgetModular(
                          hintText: "Search for Amenities...",
                          iconResolver: (String iconName) {
                            switch (iconName) {
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
                              default:
                                // fallback if unknown
                                return Icons
                                    .party_mode; // or your preferred fallback // Fallback icon
                            }
                          },
                          collectionName: 'amenities',
                          titleFieldName: 'title',
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                // Padding(
                //   padding: EdgeInsets.all(16.0),
                //   child: Column(
                //     children: [
                //       Row(
                //         children: [
                //           Text(
                //             "Want address to be visible",
                //             style: TextStyle(
                //               color: primaryDark,
                //               fontSize: 14.sp,
                //               fontWeight: FontWeight.w200,
                //             ),
                //           ),
                //           SizedBox(width: 5),
                //           Icon(Icons.help_outline,
                //               color: primaryPink, size: 14.sp),
                //           Spacer(),
                //           Switch(
                //             value: isAddressVisible,
                //             onChanged: (value) {
                //               setState(() {
                //                 isAddressVisible = value;
                //               });
                //             },
                //             activeColor: primaryOrange,
                //           ),
                //         ],
                //       ),
                //       SizedBox(height: 16),
                //       Container(
                //         decoration: BoxDecoration(
                //           gradient: gradient,
                //           borderRadius: BorderRadius.all(Radius.circular(10)),
                //           boxShadow: const [
                //             BoxShadow(
                //               color: Colors.black12,
                //               offset: Offset(0, 10),
                //               blurRadius: 6,
                //             ),
                //           ],
                //           border: Border.all(color: primaryDark, width: 1),
                //         ),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           mainAxisSize: MainAxisSize.min,
                //           children: [
                //             Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: Column(
                //                 mainAxisAlignment: MainAxisAlignment.start,
                //                 mainAxisSize: MainAxisSize.min,
                //                 children: [
                //                   Padding(
                //                     padding: const EdgeInsets.only(bottom: 4.0),
                //                     child: Text(
                //                       "Date",
                //                       style: TextStyle(
                //                         color: primaryDark,
                //                         fontSize: 12.sp,
                //                         fontWeight: FontWeight.w100,
                //                       ),
                //                     ),
                //                   ),
                //                   const Icon(
                //                     Icons.date_range_sharp,
                //                     color: primaryDark,
                //                   ),
                //                 ],
                //               ),
                //             ),
                //             Expanded(
                //               child: Padding(
                //                 padding: EdgeInsets.only(left: 7.w),
                //                 child: TextFormField(
                //                   controller: dateOfBirthController,
                //                   readOnly: true,
                //                   textAlign: TextAlign.left,
                //                   onTap: () async {
                //                     // Show date picker (your existing code)
                //                   },
                //                   style: TextStyle(
                //                     color: primaryDark,
                //                   ),
                //                   decoration: const InputDecoration(
                //                     border: InputBorder.none,
                //                     contentPadding:
                //                         EdgeInsets.symmetric(horizontal: 8),
                //                   ),
                //                 ),
                //               ),
                //             ),
                //             const Icon(
                //               Icons.keyboard_arrow_right,
                //               color: primaryDark,
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeatureChip(String label, IconData icon) {
    return Chip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: primaryOrange, size: 12.sp),
          SizedBox(width: 1.w),
          Text(
            label,
            style: TextStyle(
              color: primaryDark,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.w),
      ),
    );
  }
}
