import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tipsy/viewmodels/event_model.dart';
import 'package:flutter_tipsy/viewmodels/user_model.dart';
import 'package:flutter_tipsy/viewmodels/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../utils/constants.dart';
import '../../utils/enums.dart';
import '../../viewmodels/create_event_view_model.dart';
import '../../widgets/background_widget.dart';
import '../../widgets/firestore_chips.dart';
import '../../widgets/full_screen_image.dart';
import '../../widgets/gradient_button.dart';

class PartyDetailPage extends StatefulWidget {
  final bool isPreview;
  final EventModel? eventModel;

  const PartyDetailPage({
    Key? key,
    required this.isPreview,
    this.eventModel,
  }) : super(key: key);

  @override
  State<PartyDetailPage> createState() => _PartyDetailPageState();
}

class _PartyDetailPageState extends State<PartyDetailPage> {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  // If you want to use images from the ViewModel, you can read them in initState
  // or directly from the build method.
  // Example local images (just for demonstration):
  late List<String> _images = [];
  UserDataModel userData = UserDataModel(
      email: '',
      accountType: false,
      bio: '',
      fullName: '',
      dateOfBirth: '',
      isPhoneVisible: false,
      phone: '',
      profilePictureUrl: '',
      relationshipStatus: 0,
      sex: 0,
      uid: '');

  double _bottomContainerHeightFactor = 0.3;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    super.dispose();
  }

  /// Example Firestore fetch. Replace with your collection and field as needed.
  Future<void> fetchImagesFromFirestore() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('yourCollectionName') // Replace with your collection
          .get();

      // Collect the image URLs from the docs
      _images = snapshot.docs.map((doc) {
        return doc['imageUrl'] as String;
      }).toList();

      setState(() {}); // Trigger rebuild after fetching
    } catch (e) {
      debugPrint('Error fetching images: $e');
    }
  }

  /// Fetch images from Firestore
  Future<void> fetchUserId(String docId) async {
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('users').doc(docId).get();

    userData = UserDataModel.fromMap(userDoc.data()!);
  }

  void _handleScroll() {
    double offset = _scrollController.offset;
    double factor = 0.5 + (offset / 400) * 0.2;
    if (factor > 0.7) factor = 0.7;
    if (factor < 0.3) factor = 0.3;
    if (factor != _bottomContainerHeightFactor) {
      setState(() {
        _bottomContainerHeightFactor = factor;
      });
    }
  }

  void _showFullScreenImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImage(
          imageUrl: imageUrl,
          onDelete: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final EventModel party;
    if (widget.isPreview) {
      final eventViewModel = context.watch<CreateEventViewModel>();
      party = eventViewModel.partyData;
    } else {
      party = widget.eventModel!;
    }

    final userViewModel = context.watch<UserViewModel>();
    fetchUserId(party.uid);
    // Example usage of your fields:
    final String partyTitle = party.title;
    // ... etc.
    print(party.title);

    return Scaffold(
      body: Stack(
        children: [
          // 1) Background Image Slider

          Positioned(
            height: 70.h,
            width: 100.w,
            child: PageView.builder(
              controller: _pageController,
              itemCount: party.images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _showFullScreenImage(party.images[index]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: FastCachedImage(
                      url: party.images[index],
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(seconds: 1),
                      errorBuilder: (context, exception, stacktrace) {
                        return Text(stacktrace.toString());
                      },
                      loadingBuilder: (context, progress) {
                        return Container(
                          color: Colors.grey[450],
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (progress.isDownloading &&
                                  progress.totalBytes != null)
                                Text(
                                  '${progress.downloadedBytes ~/ 1024} / ${progress.totalBytes! ~/ 1024} kb',
                                  style: const TextStyle(color: Colors.red),
                                ),
                              SizedBox(
                                width: 120,
                                height: 120,
                                child: CircularProgressIndicator(
                                  color: Colors.red,
                                  value: progress.progressPercentage.value,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          // 2) Cancel / Back Button
          if (widget.isPreview != false)
            SafeArea(
              minimum: EdgeInsets.only(
                left: 45.w,
                top: 5.h * _bottomContainerHeightFactor,
                right: 45.w,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.cancel_rounded,
                  color: Colors.white,
                  size: 10.w,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),

          // 3) Left and Right Arrows
          Positioned(
            left: 1.w,
            height: 20.h / _bottomContainerHeightFactor,
            width: 20.w,
            child: IconButton(
              alignment: Alignment.centerLeft,
              icon: Icon(Icons.chevron_left, color: Colors.white, size: 10.w),
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
            ),
          ),
          Positioned(
            right: 1.w,
            height: 20.h / _bottomContainerHeightFactor,
            width: 20.w,
            child: IconButton(
              icon: Icon(Icons.chevron_right, color: Colors.white, size: 10.w),
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
            ),
          ),

          // 4) Bottom Content Card
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              height: 120.h * _bottomContainerHeightFactor,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5.h),
                  topRight: Radius.circular(5.h),
                ),
                color: Colors.white,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(child: BackgroundWidget()),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollUpdateNotification) {
                          _handleScroll();
                        }
                        return false;
                      },
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Example Title Box
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title Row
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        partyTitle.isNotEmpty
                                            ? partyTitle
                                            : "Rave Party",
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w700,
                                          color: primaryDark,
                                        ),
                                      ),
                                      Text(
                                        "Free",
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w700,
                                          color: primaryDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 1.h),

                                  // Example of reading from your model...
                                  Text(
                                    "Theme: ${partyTitle.isNotEmpty ? partyTitle : "--"}",
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: primaryDark,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    party.description.isNotEmpty
                                        ? party.description
                                        : "Rave Party ... (sample description)",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),

                                  // If you have docIds for music, foods, etc.
                                  FirestoreChips(
                                      docIds: party.music +
                                          party.foodsDrinks +
                                          party.amenities),
                                  const SizedBox(height: 20),

                                  // FirestoreChips(
                                  //     collectionName: 'drinks_foods'),
                                  // const SizedBox(height: 20),
                                  //
                                  // FirestoreChips(collectionName: 'amenities'),
                                  // SizedBox(height: 2.h),

                                  // C) Date/Time/Location/Guests
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(Icons.calendar_month,
                                                  size: 4.w),
                                              SizedBox(width: 1.w),
                                              Text(
                                                party.date != null
                                                    ? "${party.date}"
                                                    : "5-5-2023",
                                                style: TextStyle(
                                                  color: primaryDark,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "11:00 PM",
                                                style: TextStyle(
                                                  color: primaryDark,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                              SizedBox(width: 1.w),
                                              Icon(Icons.access_time,
                                                  size: 4.w),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 1.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                // Request to see location action
                                              },
                                              child: Wrap(
                                                children: [
                                                  Icon(Icons.map, size: 4.w),
                                                  SizedBox(width: 1.w),
                                                  Text(
                                                    party.isAddressVisible ||
                                                            party.requestStatus ==
                                                                RequestStatus
                                                                    .accepted
                                                        ? party.address
                                                        : "Request to see location",
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade700,
                                                      fontSize: 16.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "${party.currGuests}\\${party.maxGuests}",
                                                style: TextStyle(
                                                  color: primaryDark,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                              Icon(Icons.group, size: 4.w),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Divider(
                              thickness: 1,
                              color: Colors.grey.shade300,
                            ),
                            SizedBox(height: 2.h),

                            // Hosted By
                            Text(
                              "Hosted By",
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
                                color: primaryDark,
                              ),
                            ),
                            SizedBox(height: 1.h),

                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  )
                                ],
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      "https://images.unsplash.com/photo-1607746882042-944635dfe10e?fit=crop&w=100&q=80",
                                    ),
                                    radius: 30,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              userData?.uid ?? "",
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600,
                                                color: primaryDark,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Icon(
                                              Icons.verified,
                                              color: Colors.green,
                                              size: 16.sp,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 0.5.h),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.person_add_alt_1,
                                              color: Colors.blue,
                                              size: 16.sp,
                                            ),
                                            SizedBox(width: 1.w),
                                            Text(
                                              "Follow",
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                            SizedBox(width: 3.w),
                                            Icon(
                                              Icons.call,
                                              color: Colors.red,
                                              size: 16.sp,
                                            ),
                                            SizedBox(width: 1.w),
                                            Text(
                                              userData?.phone ?? "",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: primaryDark,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 1.h),
                                        Row(
                                          children: [
                                            Text(
                                              "Reviews",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: primaryDark,
                                              ),
                                            ),
                                            SizedBox(width: 1.w),
                                            Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 16.sp,
                                            ),
                                            Text(
                                              "4.9",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: primaryDark,
                                              ),
                                            ),
                                            SizedBox(width: 3.w),
                                            // Guests profile images
                                            Stack(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    "https://images.unsplash.com/photo-1544723795-3fb6469f5b39?fit=crop&w=100&q=80",
                                                  ),
                                                  radius: 12,
                                                ),
                                                Positioned(
                                                  left: 18,
                                                  child: CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                      "https://images.unsplash.com/photo-1544723795-3e5b03c240f2?fit=crop&w=100&q=80",
                                                    ),
                                                    radius: 12,
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 36,
                                                  child: CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                      "https://images.unsplash.com/photo-1527980965255-d3b416303d12?fit=crop&w=100&q=80",
                                                    ),
                                                    radius: 12,
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 54,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.grey.shade300,
                                                    radius: 12,
                                                    child: Text(
                                                      "200+",
                                                      style: TextStyle(
                                                        fontSize: 8.sp,
                                                        color: primaryDark,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 7.h),
                            // More UI...
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 5) "Request" Button
          SafeArea(
            minimum: EdgeInsets.only(
              left: 25.w,
              right: 25.w,
              top: 95.h,
              bottom: -10.h,
            ),
            child: GradientButton(
              onPressed: () {
                // Handle Request
              },
              textColor: primaryDark,
              height: 5.h,
              text: "Request",
              padding: const EdgeInsets.all(0),
              radius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
