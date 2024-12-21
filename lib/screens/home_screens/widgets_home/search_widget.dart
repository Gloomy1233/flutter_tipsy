import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/constants.dart';
import '../../common_screens/party_details_screen.dart';

//Example primary colors - adjust to match your UI
final Color chipBackgroundColor = Colors.grey.shade300;
final Color searchBarColor = Colors.grey.shade200;

//Example widget that displays party themes from Firestore
class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: [
        SizedBox(height: 2.h),

        //Search bar
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          decoration: BoxDecoration(
            color: searchBarColor,
            borderRadius: BorderRadius.circular(3.w),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey, size: 16.sp),
              SizedBox(width: 2.w),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search for parties...",
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase().trim();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),

        // StreamBuilder that listens to the partyThemes collection
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('partyThemes')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    "No party themes found.",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              // Filter documents based on search query if needed
              final filteredDocs = snapshot.data!.docs.where((doc) {
                final title = (doc['Title'] ?? '').toString().toLowerCase();
                return title.contains(_searchQuery);
              }).toList();

              if (filteredDocs.isEmpty) {
                return Center(
                  child: Text(
                    "No matching party themes.",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return SingleChildScrollView(
                child: Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: filteredDocs.map((doc) {
                    final title = doc['Title'] ?? 'Unknown';

                    final iconUrl = doc['icon'] ?? '';

                    return _buildFeatureChipFromData(
                        title: doc['Title'] ?? 'Unknown',
                        activities: doc['Activities'] ?? 'Unknown',
                        attire: doc['Attire'] ?? 'Attire',
                        decor: doc['Decor'] ?? 'Decor',
                        iconUrl: '',
                        imageUrl: doc['image'] ?? '');
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureChipFromData({
    required String title,
    required String activities,
    required String attire,
    required String decor,
    required String iconUrl,
    required String imageUrl,
  }) {
    return GestureDetector(
      onTap: () {
        //Navigate to Party/DetailPage with the provided data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PartyDetailPage(
              title: title,
              activities: activities,
              attire: attire,
              decor: decor,
              iconUrl: iconUrl,
              imageUrl: imageUrl,
            ),
          ),
        );
      },
      child: Chip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconUrl.isNotEmpty
                ? Image.network(
                    iconUrl,
                    width: 12.sp,
                    height: 12.sp,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error, color: Colors.red, size: 12.sp);
                    },
                  )
                : Icon(Icons.image_not_supported,
                    color: Colors.red, size: 12.sp),
            SizedBox(width: 1.w),
            Text(
              title,
              style: TextStyle(
                color: primaryDark,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.w),
        ),
        backgroundColor: chipBackgroundColor,
      ),
    );
  }
}
