import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/registration_viewmodel.dart'; // Optional: For file storage management

class Step4Screen extends StatefulWidget {
  const Step4Screen({super.key});

  @override
  _Step4ScreenState createState() => _Step4ScreenState();
}

final ImagePicker _picker = ImagePicker();

class _Step4ScreenState extends State<Step4Screen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegistrationViewModel>(context);

    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Picture Section
          GestureDetector(
            onTap: () => _pickImage(context, viewModel),
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.grey[300],
              backgroundImage: viewModel.profilePicture != null
                  ? FileImage(viewModel.profilePicture!) // Show selected image
                  : null,
              child: viewModel.profilePicture == null
                  ? const Text("Tap to add a picture")
                  : null,
            ),
          ),

          // Camera and Gallery Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () => _pickFromCamera(context, viewModel),
                icon: const Icon(Icons.camera_alt, size: 30),
              ),
              IconButton(
                onPressed: () => _pickImage(context, viewModel),
                icon: const Icon(Icons.upload_file, size: 30),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> _requestGalleryPermission() async {
    if (kIsWeb) return true;
    final status = await Permission.photos.request();
    return status.isGranted;
  }

  Future<void> _pickImage(
      BuildContext context, RegistrationViewModel viewModel) async {
    if (await _requestGalleryPermission()) {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        viewModel.setProfilePicture(File(pickedFile.path));
        debugPrint("Gallery image selected at: ${pickedFile.path}");
      } else {
        debugPrint("No image selected");
      }
    } else {
      debugPrint("Gallery permission denied");
    }
  }

  Future<void> _pickFromCamera(
      BuildContext context, RegistrationViewModel viewModel) async {
    if (await _requestCameraPermission()) {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        viewModel.setProfilePicture(File(pickedFile.path));
        debugPrint("Camera image captured at: ${pickedFile.path}");
      } else {
        debugPrint("No image captured");
      }
    } else {
      debugPrint("Camera permission denied");
    }
  }
}
