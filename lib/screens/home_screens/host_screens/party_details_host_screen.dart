import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tipsy/viewmodels/event_model.dart';
import 'package:flutter_tipsy/viewmodels/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/constants.dart';
import '../../../widgets/background_widget.dart';
import '../../../widgets/firestore_chips.dart';
import '../../../widgets/full_screen_image.dart';
import 'organizer_screens/organizer_screen.dart';

/// This is an example page for a *Host* viewing their own party.
/// It has a TabBar with three tabs: Info, Photos, Requests.
/// The bottom button is "Cancel Event" instead of "Request."
class PartyDetailHostPage extends StatefulWidget {
  final EventModel eventModel;

  const PartyDetailHostPage({
    Key? key,
    required this.eventModel,
  }) : super(key: key);

  @override
  State<PartyDetailHostPage> createState() => _PartyDetailHostPageState();
}

class _PartyDetailHostPageState extends State<PartyDetailHostPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late Timer _longPressTimer;
  bool _isLongPressing = false;
  bool showPending = true;
  bool showAccepted = false;
  bool showRejected = false;
  late TabController _tabController;

  UserDataModel hostData = UserDataModel(
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
      uid: '',
      eventIds: []);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchHostData(widget.eventModel.uid);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Fetch the host's user document from Firestore
  Future<void> _fetchHostData(String hostId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(hostId)
          .get();

      if (doc.exists && doc.data() != null) {
        setState(() {
          hostData = UserDataModel.fromMap(doc.data()!);
        });
      }
    } catch (e) {
      debugPrint('Error fetching host data: $e');
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
    final event = widget.eventModel;

    return Scaffold(
      body: Stack(
        children: [
          /// ========== 1) Top Hero Image Slider ==========
          Positioned(
            height: 70.h,
            width: 100.w,
            child: PageView.builder(
              controller: _pageController,
              itemCount: event.images.length,
              itemBuilder: (context, index) {
                final imageUrl = event.images[index];
                return GestureDetector(
                  onTap: () => _showFullScreenImage(imageUrl),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: FastCachedImage(
                      url: imageUrl,
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

          /// ========== 2) Back Button ==========
          SafeArea(
            minimum: EdgeInsets.only(
              left: 45.w,
              top: 5.h,
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

          /// ========== 3) Left & Right Arrows for the PageView ==========
          Positioned(
            left: 1.w,
            height: 20.h,
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
            height: 20.h,
            width: 20.w,
            child: IconButton(
              alignment: Alignment.centerRight,
              icon: Icon(Icons.chevron_right, color: Colors.white, size: 10.w),
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
            ),
          ),

          /// ========== 4) Bottom Content with Tabs ==========
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              height: 70.h,
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

                  /// -- The Column inside the bottom card
                  Column(
                    children: [
                      /// ------ TabBar Row ------
                      Container(
                        margin: EdgeInsets.only(top: 1.h),
                        child: TabBar(
                          controller: _tabController,
                          indicatorColor: primaryDark,
                          labelColor: primaryDark,
                          unselectedLabelColor: Colors.grey,
                          indicatorWeight: 3.0,
                          labelStyle: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          tabs: const [
                            Tab(text: "Info"),
                            Tab(text: "Photos"),
                            Tab(text: "Requests"),
                          ],
                        ),
                      ),

                      /// ------ TabBar Views ------
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            /// Info Tab
                            _buildInfoTab(event),

                            /// Photos Tab
                            _buildPhotosTab(event),

                            /// Requests Tab
                            _buildRequestsTab(event),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /// ========== 5) Cancel Event Button ==========
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              minimum: EdgeInsets.only(bottom: 1.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: ElevatedButton(
                  onPressed: () async {
                    // For example, confirm and then remove the event
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Cancel Event?"),
                        content: const Text(
                            "Are you sure you want to cancel this event?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text("No"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text("Yes"),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      // Example: remove from Firestore
                      await FirebaseFirestore.instance
                          .collection('events')
                          .doc(event.id)
                          .delete();

                      // Then pop back
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    backgroundColor: const Color(0xFFFF6E6E), // Reddish color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Cancel Event",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ========== INFO TAB ==========
  Widget _buildInfoTab(EventModel event) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Party Title + Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                event.title.isNotEmpty ? event.title : "Rave Party",
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

          /// Description
          Text(
            event.description.isNotEmpty
                ? event.description
                : "Rave Party ... (sample description)",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 2.h),

          /// Chips (Music, Foods, Amenities)
          FirestoreChips(
              docIds: event.music + event.foodsDrinks + event.amenities),
          SizedBox(height: 2.h),

          /// Date/Time/Location/Guests
          _buildEventDetails(event),

          Divider(
            thickness: 1,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 2.h),

          /// Hosted By
          Text(
            "Hosted By",
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
              color: primaryDark,
            ),
          ),
          SizedBox(height: 1.h),
          _buildHostCard(),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildPhotosTab(EventModel event) {
    return Stack(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    (MediaQuery.of(context).size.width / 120).floor(),
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
                childAspectRatio: 1.0,
              ),
              itemCount: event.images.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  //onTap: () => _showFullScreenImage(_downloadedImageUrls[index]),
                  onLongPressStart: (details) {
                    _startLongPressTimer(index);
                  },
                  onLongPressEnd: (details) {
                    _cancelLongPressTimer();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4.0,
                          offset: Offset(2, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          SizedBox(
                            height: 150,
                            width: 150,
                            child: FastCachedImage(
                              url: event.images[index],
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
                                            style: const TextStyle(
                                                color: Colors.red)),
                                      SizedBox(
                                          width: 120,
                                          height: 120,
                                          child: CircularProgressIndicator(
                                              color: Colors.red,
                                              value: progress
                                                  .progressPercentage.value)),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          //   placeholder: (context, url) => Container(
                          //     color: Colors.grey[300],
                          //     child: Center(child: CircularProgressIndicator()),
                          //   ),
                          //   errorWidget: (context, url, error) => Container(
                          //     color: Colors.grey[300],
                          //     child: const Icon(Icons.broken_image, size: 50),
                          //   ),

                          if (_isLongPressing &&
                              _currentLongPressIndex == index)
                            Container(
                              color: Colors.black45,
                              child: Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      value: _currentProgress,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              Colors.red),
                                    ),
                                    const Text(
                                      'X',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 30),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          bottom: 8.h,
          right: 5.w,
          child: FloatingActionButton(
            onPressed: () => {}, //pickMultipleImages(userData, partyProvider),
            backgroundColor: primaryDark,
            splashColor: primaryOrange,
            child: Icon(Icons.add_photo_alternate, color: primaryPink),
          ),
        )
      ],
    );
  }

// Add a variable to keep track of the index and progress of the current long-pressed image
  int _currentLongPressIndex = -1;
  double _currentProgress = 0.0;

  void _startLongPressTimer(int index) {
    setState(() {
      _isLongPressing = true;
      _currentLongPressIndex = index; // Set the index of the long-pressed image
      _currentProgress = 0.0; // Reset progress
    });

    // Start a single periodic timer to update progress
    _longPressTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_currentProgress >= 1.0) {
        timer.cancel(); // Stop the timer when progress is complete
        _cancelLongPressTimer(); // Reset the state
        // _showDeleteDialog(index); // Show the delete dialog
      } else {
        setState(() {
          _currentProgress += 0.05; // Increment progress for smoother animation
        });
      }
    });
  }

  void _cancelLongPressTimer() {
    if (_longPressTimer.isActive) {
      _longPressTimer.cancel();
    }
    setState(() {
      _isLongPressing = false;
      _currentLongPressIndex = -1; // Reset the index after long press ends
      _currentProgress = 0.0; // Reset the progress
    });
  }

  // void _showDeleteDialog(int index) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => DeleteConfirmationDialog(
  //       title: 'Delete Image',
  //       content: 'Are you sure you want to delete this image?',
  //       cancelText: 'Cancel',
  //       confirmText: 'Delete',
  //       onCancel: () => Navigator.pop(context),
  //       onConfirm: () async {
  //         String imageUrl = _downloadedImageUrls[index];
  //
  //         try {
  //           // Delete the image from Firebase Storage
  //           final Reference storageRef =
  //           FirebaseStorage.instance.refFromURL(imageUrl);
  //           await storageRef.delete();
  //
  //           setState(() {
  //             _downloadedImageUrls.removeAt(index);
  //           });
  //           FastCachedImageConfig.deleteCachedImage(imageUrl: imageUrl);
  //           print('Image deleted successfully');
  //         } catch (e) {
  //           print('Error deleting image: $e');
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //                 content: Text('Failed to delete image. Please try again.')),
  //           );
  //         }
  //
  //         Navigator.pop(context);
  //       },
  //     ),
  //   );
  // }
  Future<void> _pickAndUploadImage(String eventId) async {
    try {
      // 1) Pick image from gallery
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) {
        // User canceled picking an image
        return;
      }

      final File imageFile = File(pickedFile.path);

      // 2) Upload to Firebase Storage
      // For uniqueness, you can create a unique filename or use a timestamp.
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('events')
          .child('$eventId/$fileName.jpg');

      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() => null);

      // 3) Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // 4) Update Firestore array
      await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .update({
        'images': FieldValue.arrayUnion([downloadUrl]),
      });

      // Optionally refresh local UI by pulling new images from Firestore
      // or just do setState() if you keep local data in memory
      setState(() {
        widget.eventModel.images.add(downloadUrl);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image uploaded successfully!')),
      );
    } catch (e) {
      debugPrint('Error picking/uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    }
  }

  final _sectionStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  Future<void> _acceptUser(EventModel event, String userId) async {
    // Move userId from pendingGuests to acceptedGuests in Firestore
    await FirebaseFirestore.instance.collection('events').doc(event.id).update({
      'pendingGuests': FieldValue.arrayRemove([userId]),
      'acceptedGuests': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> _declineUser(EventModel event, String userId) async {
    // Move userId from pendingGuests to rejectedGuests in Firestore
    await FirebaseFirestore.instance.collection('events').doc(event.id).update({
      'pendingGuests': FieldValue.arrayRemove([userId]),
      'rejectedGuests': FieldValue.arrayUnion([userId]),
    });
  }

  Widget _buildRequestsTab(EventModel event) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('events')
          .doc(event.id)
          .snapshots(),
      builder: (context, eventSnapshot) {
        if (eventSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (eventSnapshot.hasError) {
          return Center(child: Text("Error: ${eventSnapshot.error}"));
        }
        if (!eventSnapshot.hasData || !eventSnapshot.data!.exists) {
          return const Center(child: Text("Event not found."));
        }

        final eventData = eventSnapshot.data!.data()!;
        final pendingIds = List<String>.from(eventData['pendingGuests'] ?? []);
        final acceptedIds =
            List<String>.from(eventData['acceptedGuests'] ?? []);
        final rejectedIds =
            List<String>.from(eventData['rejectedGuests'] ?? []);

        if (pendingIds.isEmpty && acceptedIds.isEmpty && rejectedIds.isEmpty) {
          return const Center(child: Text("No Requests"));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionToggleButton(
                title: 'Pending',
                isActive: showPending,
                onTap: () {
                  setState(() {
                    showPending = !showPending;
                  });
                },
              ),
              if (pendingIds.isNotEmpty && showPending) ...[
                _UsersStreamList(
                  userIds: pendingIds,
                  status: "pending",
                  event: event,
                  onAccept: _acceptUser,
                  onDecline: _declineUser,
                ),
              ],
              SectionToggleButton(
                title: 'Accepted',
                isActive: showAccepted,
                onTap: () {
                  setState(() {
                    showAccepted = !showAccepted;
                  });
                },
              ),
              if (acceptedIds.isNotEmpty && showAccepted) ...[
                _UsersStreamList(
                  userIds: acceptedIds,
                  status: "accepted",
                  event: event,
                  onAccept: _acceptUser,
                  onDecline: _declineUser,
                ),
              ],
              SectionToggleButton(
                title: 'Rejected',
                isActive: showRejected,
                onTap: () {
                  setState(() {
                    showRejected = !showRejected;
                  });
                },
              ),
              if (rejectedIds.isNotEmpty && showRejected) ...[
                _UsersStreamList(
                  userIds: rejectedIds,
                  status: "rejected",
                  event: event,
                  onAccept: _acceptUser,
                  onDecline: _declineUser,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  /// Build the bottom portion of the Info Tab: date/time/location/guest count
  Widget _buildEventDetails(EventModel party) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Date
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.calendar_month, size: 4.w),
                SizedBox(width: 1.w),
                Text(
                  party.date.toString() ?? "5-5-2023",
                  style: TextStyle(
                    color: primaryDark,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
            // Time
            Row(
              children: [
                Text(
                  party.date.toString() ?? "11:00 PM",
                  style: TextStyle(
                    color: primaryDark,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(width: 1.w),
                Icon(Icons.access_time, size: 4.w),
              ],
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Location
            Expanded(
              child: Wrap(
                children: [
                  Icon(Icons.map, size: 4.w),
                  SizedBox(width: 1.w),
                  Text(
                    party.address.isNotEmpty
                        ? party.address
                        : "Address unknown",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
            // Guest count
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${party.acceptedGuests.length}\\${party.maxGuests}",
                  style: TextStyle(
                    color: primaryDark,
                    fontSize: 13.sp,
                  ),
                ),
                Icon(Icons.group, size: 4.w),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// Build a card showing info about the Host (the user who created this event).
  Widget _buildHostCard() {
    return Container(
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
              hostData.profilePictureUrl ?? "https://via.placeholder.com/150",
            ),
            radius: 30,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      hostData.fullName.isNotEmpty
                          ? hostData.fullName
                          : "No Name",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: primaryDark,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(Icons.verified, color: Colors.green, size: 16.sp),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Icon(Icons.call, color: Colors.red, size: 16.sp),
                    SizedBox(width: 1.w),
                    Text(
                      hostData.phone.isNotEmpty ? hostData.phone : "No phone",
                      style: TextStyle(fontSize: 12.sp, color: primaryDark),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Text(
                      "Reviews",
                      style: TextStyle(fontSize: 12.sp, color: primaryDark),
                    ),
                    SizedBox(width: 1.w),
                    Icon(Icons.star, color: Colors.amber, size: 16.sp),
                    Text(
                      "4.9",
                      style: TextStyle(fontSize: 12.sp, color: primaryDark),
                    ),
                    SizedBox(width: 3.w),
                    // Example: small set of friend profile images
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
                            backgroundImage: NetworkImage(
                              "https://images.unsplash.com/photo-1544723795-3e5b03c240f2?fit=crop&w=100&q=80",
                            ),
                            radius: 12,
                          ),
                        ),
                        Positioned(
                          left: 36,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              "https://images.unsplash.com/photo-1527980965255-d3b416303d12?fit=crop&w=100&q=80",
                            ),
                            radius: 12,
                          ),
                        ),
                        Positioned(
                          left: 54,
                          child: CircleAvatar(
                            backgroundColor: Colors.grey.shade300,
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
    );
  }
}

/// A widget that takes a list of user IDs, queries them in real time,
/// then builds a ListView of request cards.
class _UsersStreamList extends StatelessWidget {
  final List<String> userIds;
  final String status; // "pending", "accepted", "rejected"
  final EventModel event;
  final Future<void> Function(EventModel, String) onAccept;
  final Future<void> Function(EventModel, String) onDecline;

  _UsersStreamList({
    Key? key,
    required this.userIds,
    required this.status,
    required this.event,
    required this.onAccept,
    required this.onDecline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userIds.isEmpty) {
      return const SizedBox();
    }

    // 1) If we have user IDs, stream them in real time:
    //    If userIds > 10, remember Firestore's 'whereIn' limit is 10.
    //    You might have to chunk them or handle that logic separately.
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where(FieldPath.documentId, whereIn: userIds)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            // Means these user docs might not exist or are still loading
            return const SizedBox();
          }

          // 2) Convert each doc into a UserDataModel
          final users = docs.map((doc) {
            return UserDataModel.fromMap(doc.data());
          }).toList();

          // 3) Build a ListView of request cards
          return ListView.separated(
            itemCount: users.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => SizedBox(height: 2),
            itemBuilder: (context, index) {
              final user = users[index];
              return buildRequestCard(
                user: user,
                event: event,
                status: status,
                onAccept: () => onAccept(event, user.uid),
                onDecline: () => onDecline(event, user.uid),
              );
            },
          );
        },
      ),
    );
  }

  /// A single request card: user name, accept/decline
// Example colors (adjust to your design)
  final Color darkCardColor = Color(0xFF424256);
  final Color nameColor = Color(0xFFFFBFE8); // Pastel pink for user name
  final Color greenColor = Color(0xFF46E891);
  final Color redColor = Color(0xFFFF6E6E);
  final Color iconColor = Color(0xFFBEBEFF);

  Widget buildRequestCard({
    required UserDataModel user,
    required EventModel event,
    required String status, // <--- new
    required VoidCallback onAccept,
    required VoidCallback onDecline,
  }) {
    return Container(
      // Large border radius for that pill/rounded style
      decoration: BoxDecoration(
        color: darkCardColor,
        borderRadius: BorderRadius.circular(40),
      ),
      padding: EdgeInsets.all(2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ===== Left: Profile Image =====
          CircleAvatar(
            backgroundImage: NetworkImage(
              user.profilePictureUrl ?? "https://via.placeholder.com/150",
            ),
            radius: 30,
          ),
          SizedBox(width: 3.w),

          // ===== Middle: Name, Stats, Contact Info =====
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -- Name --
                Text(
                  user.fullName,
                  style: TextStyle(
                    color: nameColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 0.7.h),

                // -- Likes/Dislikes Row --
                Row(
                  children: [
                    Icon(Icons.thumb_up, color: greenColor, size: 14.sp),
                    SizedBox(width: 1.w),
                    Text("32", // or user.likesCount
                        style: TextStyle(color: Colors.white, fontSize: 12.sp)),
                    SizedBox(width: 3.w),
                    Icon(Icons.call, color: Colors.orange, size: 14.sp),
                    SizedBox(width: 1.w),
                    Text(
                      user.phone.isNotEmpty ? user.phone : "-",
                      style: TextStyle(color: Colors.white, fontSize: 12.sp),
                    ),
                  ],
                ),
                SizedBox(height: 0.7.h),

                // -- Dislike & Social Icons Row --
                Row(
                  children: [
                    Icon(Icons.thumb_down, color: redColor, size: 14.sp),
                    SizedBox(width: 1.w),
                    Text(
                      "1", // or user.dislikesCount
                      style: TextStyle(color: Colors.white, fontSize: 12.sp),
                    ),
                    SizedBox(width: 3.w),
                    Icon(Icons.g_mobiledata, color: iconColor, size: 18.sp),
                    SizedBox(width: 2.w),
                    Icon(Icons.facebook, color: Colors.blue, size: 16.sp),
                    SizedBox(width: 2.w),
                    Icon(Icons.camera_alt, color: Colors.purple, size: 16.sp),
                  ],
                ),
              ],
            ),
          ),

          // ===== Right Side: Buttons OR Status Pill =====
          SizedBox(width: 3.w),
          _buildRightSide(status, onAccept, onDecline),
        ],
      ),
    );
  }

  Widget _buildRightSide(
      String status, VoidCallback onAccept, VoidCallback onDecline) {
    if (status == "pending") {
      // Show Accept/Decline buttons
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton.icon(
            onPressed: onAccept,
            style: TextButton.styleFrom(
              foregroundColor: greenColor,
              shape: const StadiumBorder(),
              side: BorderSide(color: greenColor),
            ),
            icon: Icon(Icons.check, color: greenColor, size: 16.sp),
            label: Text("Accept",
                style: TextStyle(fontSize: 12.sp, color: greenColor)),
          ),
          SizedBox(height: 1.h),
          TextButton.icon(
            onPressed: onDecline,
            style: TextButton.styleFrom(
              foregroundColor: redColor,
              shape: const StadiumBorder(),
              side: BorderSide(color: redColor),
            ),
            icon: Icon(Icons.close, color: redColor, size: 16.sp),
            label: Text("Decline",
                style: TextStyle(fontSize: 12.sp, color: redColor)),
          ),
        ],
      );
    } else if (status == "accepted") {
      // Show a "✓ Accepted" pill
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: greenColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(Icons.check, color: Colors.black87, size: 16.sp),
            SizedBox(width: 6),
            Text(
              "Accepted",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    } else if (status == "rejected") {
      // Show a "✕ Rejected" pill
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: redColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(Icons.close, color: Colors.black87, size: 16.sp),
            SizedBox(width: 6),
            Text(
              "Rejected",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    // If something else happens, or you have other states
    return const SizedBox();
  }
}
