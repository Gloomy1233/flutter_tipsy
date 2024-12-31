import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/constants.dart';
import '../../common_screens/party_details_screen.dart';

//Example primary colors - adjust to match your UI
final Color chipBackgroundColor = Colors.grey.shade300;
final Color searchBarColor = Colors.grey.shade200;

//Example widget that displays party themes from Firestore
class SearchWidgetThemes extends StatefulWidget {
  const SearchWidgetThemes({super.key});

  @override
  State<SearchWidgetThemes> createState() => _SearchWidgetThemesState();
}

class _SearchWidgetThemesState extends State<SearchWidgetThemes> {
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

class SearchWidgetModular extends StatefulWidget {
  /// The Firestore collection to query (e.g. "music", "partyThemes", etc.).
  final String collectionName;

  /// The name of the field in each document to use as the "title" or
  /// searchable text (e.g. "Genre", "Title", "Name", etc.).
  final String titleFieldName;

  /// An optional callback function to convert a string (icon name) into an IconData.
  final IconData Function(String)? iconResolver;

  const SearchWidgetModular({
    Key? key,
    required this.collectionName, // e.g. 'music'
    required this.titleFieldName, // e.g. 'Genre'
    this.iconResolver,
  }) : super(key: key);

  @override
  State<SearchWidgetModular> createState() => _SearchWidgetModularState();
}

class _SearchWidgetModularState extends State<SearchWidgetModular> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  /// If true, we show both selected & unselected chips.
  /// If false, we show only selected chips.
  bool _showUnselected = true;

  String _searchQuery = '';

  /// Keeps track of selected document IDs so they stay pinned.
  final List<String> _selectedDocIds = [];

  @override
  void initState() {
    super.initState();
    // Listen for focus changes on the search bar:
    _searchFocusNode.addListener(() {
      // If the search bar loses focus, hide unselected chips.
      if (!_searchFocusNode.hasFocus) {
        setState(() {
          _showUnselected = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // If user taps anywhere outside the textfield, lose focus (so _showUnselected = false).
      onTap: () {
        FocusScope.of(context).unfocus(); // triggers the listener above
      },
      behavior: HitTestBehavior.translucent,
      child: Wrap(
        spacing: 2.w,
        runSpacing: 1.h,
        children: [
          _buildSearchBar(),
          _buildChipList(),
        ],
      ),
    );
  }

  /// Builds the search bar at the top
  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey, size: 16.sp),
          SizedBox(width: 2.w),
          Expanded(
            child: TextField(
              focusNode: _searchFocusNode,
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Search for parties...",
                border: InputBorder.none,
              ),
              onTap: () {
                // When user taps inside the field, let's show unselected chips again
                setState(() {
                  _showUnselected = true;
                });
              },
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase().trim();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the container that includes our StreamBuilder and the chip list.
  Widget _buildChipList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(widget.collectionName) // <-- Use passed-in collectionName
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          // No data => show a small placeholder / minimal height
          return SizedBox(
            height: 2.h, // or 0 for fully collapsed
            child: const Center(
              child: Text("No items found."),
            ),
          );
        }

        final docs = snapshot.data!.docs;

        // 1. Separate selected docs from unselected docs
        final selectedDocs =
            docs.where((doc) => _selectedDocIds.contains(doc.id)).toList();
        final unselectedDocs =
            docs.where((doc) => !_selectedDocIds.contains(doc.id)).toList();
        if (_searchQuery == "") {
          unselectedDocs.clear();
        }
        // 2. Filter unselected docs by search query if _showUnselected is true
        List<QueryDocumentSnapshot> filteredUnselectedDocs = [];
        if (_showUnselected) {
          filteredUnselectedDocs = unselectedDocs.where((doc) {
            // Use passed-in titleFieldName (e.g. 'Genre', 'Title')
            final titleValue =
                (doc[widget.titleFieldName] ?? '').toString().toLowerCase();
            return titleValue.contains(_searchQuery);
          }).toList();
        }

        // 3. Combine selected docs (pinned) + filtered unselected docs
        final finalDocs = [...selectedDocs, ...filteredUnselectedDocs];

        // If absolutely no docs to show, return minimal or zero height
        if (finalDocs.isEmpty) {
          return SizedBox(
            height: 2.h,
            child: const Center(
              child: Text("No matching items."),
            ),
          );
        }

        return ConstrainedBox(
          constraints: BoxConstraints(
            // Let it grow up to 20% (example) or 30% of screen height, etc.
            maxHeight: 15.h,
          ),
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 2,
              runSpacing: 0,
              children: finalDocs.map((doc) {
                final docId = doc.id;
                final titleValue =
                    (doc[widget.titleFieldName] ?? 'Unknown').toString();
                final iconName = (doc['icon'] ?? '').toString();

                final isSelected = _selectedDocIds.contains(docId);

                return GestureDetector(
                  onTap: () {
                    if (!isSelected) {
                      // Select it
                      setState(() {
                        _selectedDocIds.add(docId);
                      });
                    } else {
                      // Optional: if you want to allow unselect on tap:
                      // setState(() {
                      //   _selectedDocIds.remove(docId);
                      // });
                    }
                  },
                  child: Chip(
                    backgroundColor: isSelected ? primaryOrange : primaryDark,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.iconResolver != null
                              ? widget.iconResolver!(iconName)
                              : Icons.error_outline,
                          color: isSelected ? primaryDark : primaryOrange,
                          size: 15.sp,
                        ),
                        Text(
                          titleValue,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isSelected ? primaryDark : primaryOrange,
                          ),
                        ),
                        if (isSelected)
                          GestureDetector(
                            onTap: () {
                              // Remove from selected
                              setState(() {
                                _selectedDocIds.remove(docId);
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: 2.w),
                              child: Icon(
                                Icons.close_rounded,
                                size: 15.sp,
                                color: primaryDark,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
