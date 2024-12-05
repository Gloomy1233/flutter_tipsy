import 'dart:async';
import 'dart:io';

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tipsy/viewmodels/user_model.dart';
import 'package:flutter_tipsy/widgets/show_delete_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    _loadUploadedImages();
  }

  Future<void> _loadUploadedImages() async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    if (userViewModel.userDataModel != null) {
      String uid = userViewModel.userDataModel!.uid;
      List<String> urls = [];

      try {
        // List all files in the user's directory
        ListResult result = await FirebaseStorage.instance
            .ref()
            .child('profile_uploads/$uid')
            .listAll();

        for (Reference ref in result.items) {
          String downloadUrl = await ref.getDownloadURL();
          urls.add(downloadUrl);
        }

        setState(() {
          _downloadedImageUrls = urls;
        });
      } catch (e) {
        print('Error loading images: $e');
      }
    }
  }

  Future<void> pickMultipleImages(UserDataModel userData) async {
    try {
      final List<XFile> selectedImages = await _picker.pickMultiImage();
      setState(() {
        _images = selectedImages;
        _uploadingFlags = List.generate(selectedImages.length, (_) => true);
      });

      // Start uploading images immediately
      for (int i = 0; i < _images!.length; i++) {
        _uploadImage(userData, _images![i], i);
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  Future<void> _uploadImage(
      UserDataModel userData, XFile imageFile, int index) async {
    File file = File(imageFile.path);
    String fileName =
        imageFile.path.substring(imageFile.path.lastIndexOf('/') + 1);

    try {
      // Upload to Firebase Storage
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_uploads/${userData.uid}/$fileName');
      await storageRef.putFile(file);

      // Get download URL
      String downloadURL = await storageRef.getDownloadURL();
      print('Uploaded $fileName, download URL: $downloadURL');

      // Update UI after upload
      setState(() {
        _uploadingFlags[index] = false;
        _downloadedImageUrls.add(downloadURL);
      });
    } catch (e) {
      print('Error uploading $fileName: $e');
      setState(() {
        _uploadingFlags[index] =
            false; // Indicate upload finished even if it failed
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);

    if (userViewModel.userDataModel == null) {
      userViewModel.fetchUserData();
    }
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.cyanAccent,
              Colors.lightBlueAccent,
              Colors.deepPurpleAccent,
              Colors.purpleAccent,
              Colors.pinkAccent,
              Colors.lightGreenAccent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: userViewModel.userDataModel != null
            ? _buildProfileContent(userViewModel.userDataModel!)
            : _buildLoadingContent());
  }

  Widget _buildProfileContent(UserDataModel userData) {
    return Stack(
      children: [
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
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () => pickMultipleImages(userData),
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.add_photo_alternate, color: Colors.white),
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
