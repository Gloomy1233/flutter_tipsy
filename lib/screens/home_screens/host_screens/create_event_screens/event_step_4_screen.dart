import 'dart:async';
import 'dart:io';

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tipsy/utils/constants.dart';
import 'package:flutter_tipsy/viewmodels/user_model.dart';
import 'package:flutter_tipsy/widgets/show_delete_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

import '../../../../viewmodels/create_event_view_model.dart';
import '../../../../viewmodels/current_user.dart';
import '../../../../viewmodels/user_view_model.dart';

class EventStep4Screen extends StatefulWidget {
  const EventStep4Screen({super.key});

  @override
  _EventStep4ScreenState createState() => _EventStep4ScreenState();
}

class _EventStep4ScreenState extends State<EventStep4Screen> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _images = [];
  List<String> _downloadedImageUrls = [];
  List<bool> _uploadingFlags = [];
  late Timer _longPressTimer;
  bool _isLongPressing = false;
  bool _isMounted = true;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    final partyProvider =
        Provider.of<CreateEventViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = CurrentUser().user;
      if (currentUser != null) {
        partyProvider.acceptedGuests = List<String>.filled(1, currentUser.uid);
        partyProvider.bucketId = Uuid().v4();
      }
    });
    _loadUploadedImages(partyProvider);
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> _loadUploadedImages(CreateEventViewModel partyProvider) async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    if (userViewModel.userDataModel != null) {
      String uid = userViewModel.userDataModel!.uid;
      List<String> urls = [];

      try {
        // List all files in the user's directory
        ListResult result = await FirebaseStorage.instance
            .ref()
            .child('event_images/$uid/${partyProvider.bucketId}')
            .listAll();

        for (Reference ref in result.items) {
          String downloadUrl = await ref.getDownloadURL();
          urls.add(downloadUrl);
        }
        if (_isMounted) {
          setState(() {
            _downloadedImageUrls = urls;
          });
        }
      } catch (e) {
        print('Error loading images: $e');
      }
    }
  }

  Future<void> pickMultipleImages(
      UserDataModel userData, CreateEventViewModel partyProvider) async {
    try {
      final List<XFile> selectedImages = await _picker.pickMultiImage();
      setState(() {
        final currentUser = CurrentUser().user;
        if (currentUser != null) {
          List<String> list = [];
          list.add(currentUser.uid);
          partyProvider.acceptedGuests = list;
        }

        _images = selectedImages;
        partyProvider.images = _downloadedImageUrls;
        _uploadingFlags = List.generate(selectedImages.length, (_) => true);
      });

      // Start uploading images immediately
      for (int i = 0; i < _images!.length; i++) {
        _uploadImage(userData, _images![i], i, partyProvider);
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  Future<void> _uploadImage(
    UserDataModel userData,
    XFile imageFile,
    int index,
    CreateEventViewModel partyProvider,
  ) async {
    setState(() {
      _uploadingFlags[index] = true; // Indicate uploading state
    });

    try {
      Reference storageRef = FirebaseStorage.instance.ref().child(
          'event_images/${userData.uid}/${partyProvider.bucketId}/${imageFile.name}');

      String downloadURL;

      if (kIsWeb) {
        Uint8List fileBytes = await imageFile.readAsBytes();
        await storageRef.putData(fileBytes);
        downloadURL = await storageRef.getDownloadURL();
      } else {
        File file = File(imageFile.path);
        UploadTask uploadTask = storageRef.putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        downloadURL = await snapshot.ref.getDownloadURL();
      }

      // Store URLs temporarily in Firestore (under a `pendingUploads` collection)
      setState(() {
        _uploadingFlags[index] = false;
        _downloadedImageUrls.add(downloadURL);
        partyProvider.images = _downloadedImageUrls;
      });
    } catch (e) {
      print('❌ Error uploading image: $e');
      setState(() {
        _uploadingFlags[index] = false; // Reset uploading flag on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    final partyProvider = Provider.of<CreateEventViewModel>(context);

    if (userViewModel.userDataModel == null) {
      userViewModel.fetchUserData();
    }
    return SizedBox(
        child: userViewModel.userDataModel != null
            ? _buildProfileContent(userViewModel.userDataModel!, partyProvider)
            : _buildLoadingContent());
  }

  Widget _buildProfileContent(
      UserDataModel userData, CreateEventViewModel partyProvider) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "Add Images For the Party    ",
            style: TextStyle(
              color: primaryDark,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Column(
          children: [
            SizedBox(height: kToolbarHeight + 20),
            SizedBox(height: 20),
            if (_downloadedImageUrls.isNotEmpty ||
                (_images != null && _images!.isNotEmpty))
              _buildScrollableImagesSection(),
          ],
        ),
        Positioned(
          bottom: 20,
          right: 40.w,
          left: 40.w,
          child: FloatingActionButton(
            onPressed: () => pickMultipleImages(userData, partyProvider),
            backgroundColor: primaryDark,
            splashColor: primaryOrange,
            child: Icon(Icons.add_photo_alternate, color: primaryPink),
          ),
        ),
      ],
    );
  }

  Widget _buildScrollableImagesSection() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (MediaQuery.of(context).size.width / 120).floor(),
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
            childAspectRatio: 1.0,
          ),
          itemCount: _downloadedImageUrls.length,
          itemBuilder: (BuildContext context, int index) {
            print(_downloadedImageUrls);
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
                          url: _downloadedImageUrls[index],
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
                                        style:
                                            const TextStyle(color: Colors.red)),
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

                      if (_isLongPressing && _currentLongPressIndex == index)
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
        _showDeleteDialog(index); // Show the delete dialog
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

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        title: 'Delete Image',
        content: 'Are you sure you want to delete this image?',
        cancelText: 'Cancel',
        confirmText: 'Delete',
        onCancel: () => Navigator.pop(context),
        onConfirm: () async {
          String imageUrl = _downloadedImageUrls[index];

          try {
            // Delete the image from Firebase Storage
            final Reference storageRef =
                FirebaseStorage.instance.refFromURL(imageUrl);
            await storageRef.delete();

            setState(() {
              _downloadedImageUrls.removeAt(index);
            });
            FastCachedImageConfig.deleteCachedImage(imageUrl: imageUrl);
            print('Image deleted successfully');
          } catch (e) {
            print('Error deleting image: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Failed to delete image. Please try again.')),
            );
          }

          Navigator.pop(context);
        },
      ),
    );
  }

  // void _showFullScreenImage(String imageUrl) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => FullScreenImage(
  //         imageUrl: imageUrl,
  //         onDelete: () {
  //           setState(() {
  //             _downloadedImageUrls.remove(imageUrl);
  //           });
  //           Navigator.pop(context);
  //         },
  //       ),
  //     ),
  //   );
  // }

  Widget _buildLoadingContent() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
