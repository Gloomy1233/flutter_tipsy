import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../utils/constants.dart';
import '../../../../widgets/app_theme_text_form_field.dart';

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
                Text(
                  "Search Party Themes",
                  style: TextStyle(
                    color: primaryDark,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                SizedBox(height: 2.h),
                AppThemeTextFormField(
                  controller: searchController,
                  labelText: "Search",
                  hintText: "Enter theme title",
                  onChanged: (value) {
                    performSearch(value.trim());
                  },
                  suffixIcon: Icon(Icons.search),
                ),
                SizedBox(height: 2.h),

                // Display Search Results
                if (searchResults.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true, // Important to prevent unbounded height
                    physics:
                        NeverScrollableScrollPhysics(), // To allow SingleChildScrollView to scroll
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final item = searchResults[index];
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(vertical: 1.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.w),
                          side: BorderSide(color: primaryDark, width: 1),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(2.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['Title'] ?? 'No Title',
                                style: TextStyle(
                                  color: primaryDark,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                "Activities: ${item['Activities'] ?? 'N/A'}",
                                style: TextStyle(
                                  color: primaryDark,
                                  fontSize: 12.sp,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                "Attire: ${item['Attire'] ?? 'N/A'}",
                                style: TextStyle(
                                  color: primaryDark,
                                  fontSize: 12.sp,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                "Decor: ${item['Decor'] ?? 'N/A'}",
                                style: TextStyle(
                                  color: primaryDark,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                Text(
                  "Features",
                  style: TextStyle(
                    color: primaryDark,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                SizedBox(height: 2.h),

                // Features Tags
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: primaryDarkLighter,
                    borderRadius: BorderRadius.circular(3.w),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: "Search for parties...",
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 0.5.h, // Adjust height
                            horizontal: 12.0, // Adjust left and right padding
                          ),
                        ),
                        style: TextStyle(fontSize: 12.sp), // Smaller font size
                      ),
                      SizedBox(height: 2.h),
                      Wrap(
                        spacing: 2.w,
                        runSpacing: 1.h,
                        children: [
                          _buildFeatureChip(
                              "Strobe Lights/Laser Lights", Icons.light),
                          _buildFeatureChip("Hot Tub", Icons.hot_tub),
                          _buildFeatureChip("Large Place", Icons.house),
                          _buildFeatureChip("Woofer-SubWoofer", Icons.speaker),
                          _buildFeatureChip(
                              "Edm-Rave-Drum n’Bass", Icons.music_note),
                          _buildFeatureChip(
                              "Bring your own booze", Icons.local_drink),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Want address to be visible",
                            style: TextStyle(
                              color: primaryDark,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(Icons.help_outline,
                              color: primaryPink, size: 14.sp),
                          Spacer(),
                          Switch(
                            value: isAddressVisible,
                            onChanged: (value) {
                              setState(() {
                                isAddressVisible = value;
                              });
                            },
                            activeColor: primaryOrange,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          gradient: gradient,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 10),
                              blurRadius: 6,
                            ),
                          ],
                          border: Border.all(color: primaryDark, width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Text(
                                      "Date",
                                      style: TextStyle(
                                        color: primaryDark,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w100,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.date_range_sharp,
                                    color: primaryDark,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 7.w),
                                child: TextFormField(
                                  controller: dateOfBirthController,
                                  readOnly: true,
                                  textAlign: TextAlign.left,
                                  onTap: () async {
                                    // Show date picker (your existing code)
                                  },
                                  style: TextStyle(
                                    color: primaryDark,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                  ),
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_right,
                              color: primaryDark,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
